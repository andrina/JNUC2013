#!/bin/bash

########################################################################
# Created By: Andrina Kelly, andrina.kelly@bellmedia.ca, Ext 4995
# Creation Date: April 2013
# Last modified: April 25th, 2013
# Brief Description: Gather diagnostic logs and submit to support
########################################################################

LOGGEDIN=`who | grep console | awk '{print $1}'`
DEFAULTMAIL=`defaults read /Users/$LOGGEDIN/Library/Preferences/com.apple.LaunchServices.plist | perl -e 'while(<>) {push @lines, $_; m~mailto~ and last} $_ = $lines[-2]; s~[^\"]+\"~~;s~\";~~;print'`
COMPUTER=`hostname`
FILE=`ls -ltr /var/tmp | tail -1 | awk '{print $9}'`
BOOTDISK=`diskutil info / | grep "Volume Name" | cut -c 30-50`
CD="/Path/to/CocoaDialog.app/Contents/MacOS/CocoaDialog"


expect <<- DONE
  set timeout -1
  spawn sysdiagnose

  # Look for  prompt
  expect "*?ontinue*"
  # send blank line (\r) to make sure we get back to gui
  send -- "\r"
  expect eof
DONE


if [ "$DEFAULTMAIL" == "com.apple.mail" ];
then

echo "tell application \"Mail\"
	set theContent to (\"Included are System Diagnostic logs from the computer ${COMPUTER}. \\r \\r Please include any details about what was going on on your machine that caused you to send us this information. \\r \\r Affected Application: \\r Is the problem reproducable: \\r Steps to reproduce: \\r Expected Results: \\r Actual Results: \\r \\r \")
	set theEmail to make new outgoing message with properties {visible:true, subject:\"System Diagnostic Logs from ${COMPUTER}\", content:theContent}
    tell theEmail
        make new recipient at end of to recipients with properties {address:\"support@yourcompany.com\"}
        make new attachment with properties {file name:\"$BOOTDISK:var:tmp:$FILE\" as alias} at after last paragraph            
		end tell
end tell" | osascript

elif [ "$DEFAULTMAIL" == "com.microsoft.outlook" ];
then

echo "tell application \"Microsoft Outlook\"
	set theContent to (\"Included are System Diagnostic logs from the computer ${COMPUTER}. <br><br> Please include any details about what was going on on your machine that caused you to send us this information. <br><br> Affected Application: <br> Is the problem reproducable: <br> Steps to reproduce: <br> Expected Results: <br> Actual Results: <br><br> \")
	set theAttachment to file \"$BOOTDISK:var:tmp:$FILE\" as alias
    set newMessage to make new outgoing message with properties {subject:\"System Diagnostic Logs from ${COMPUTER}\", content:theContent}
    make new recipient at newMessage with properties {email address:{name:\"support\", address:\"support@yourcompany.com\"}}
    make new attachment at newMessage with properties {file:\"$BOOTDISK:var:tmp:$FILE\" as alias}
    open newMessage
end tell" | osascript

else
$CD ok-msgbox --text "No Acceptable Mail Client Found" \
--informative-text "It appears that neither Apple Mail or Microsoft Outlook are being used as your default mail applications. If you wish to send the diagnostic report to support please send the resulting file to support@yourcompany.com" \
--no-newline --float
logger "No suitable mail client found"

exit 0
fi

