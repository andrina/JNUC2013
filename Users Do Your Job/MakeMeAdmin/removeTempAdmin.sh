#!/bin/bash
##############
# This is the removal script for the tempadmin.sh script. 
# This will run two times. The first time it will remove the user from
# the admin group. The second time it will disable the plist that calls
# this script. The reason for the two runs is in testing I found it would
# not finish the policy trigger and never report back to JSS that it completed. 
# You will get a report back on the first run and then it will fail to report 
# back on the second run it will then disable itself. 
##############

if [[ -f /var/uits/userToRemove ]]; then
	U=`cat /var/uits/userToRemove`
	echo "removing" $U "from admin group"
	/usr/sbin/dseditgroup -o edit -d $U -t user admin
	echo $U "has been removed from admin group"
	rm -f /var/uits/userToRemove
else
	defaults write /Library/LaunchDaemons/com.yourcompany.adminremove.plist disabled -bool true
	echo "going to unload"
	launchctl unload -w /Library/LaunchDaemons/com.yourcompany.adminremove.plist
	echo "Completed"
	rm -f /Library/LaunchDaemons/com.yourcompany.adminremove.plist
fi

exit 0