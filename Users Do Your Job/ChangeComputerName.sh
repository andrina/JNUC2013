#!/bin/sh

########################################################################
# Created By: Andrina Kelly, andrina.kelly@bellmedia.ca, Ext 4995
# Creation Date: Nov 30th 2012
# Last modified: Nov 30th, 2012
#
# Brief Description: Interactive prompt to change the computer name with scutil, used in Self Service
#
# Modification History
# Nov 30 - New Script
########################################################################

# Set CocoaDialog Location
CD="/Path/to/CocoaDialog.app/Contents/MacOS/CocoaDialog"

# Dialog to enter the computer name and the create $COMPUTERNAME variable
rv=($($CD standard-inputbox --title "Computer Name" --no-newline --informative-text "Enter the computer name you wish to set"))
COMPUTERNAME=${rv[1]}


# Set Hostname using variable created above
scutil --set HostName $COMPUTERNAME
scutil --set LocalHostName $COMPUTERNAME
scutil --set ComputerName $COMPUTERNAME

# Dialog to confirm that the hostname was changed and what it was changed to.
tb=`$CD ok-msgbox --text "Computer Name Changed!" \
--informative-text "The computer name has been changed to $COMPUTERNAME" \
--no-newline --float`
if [ "$tb" == "1" ]; then
echo "User said OK"
elif [ "$tb" == "2" ]; then
echo "Canceling"
exit
fi