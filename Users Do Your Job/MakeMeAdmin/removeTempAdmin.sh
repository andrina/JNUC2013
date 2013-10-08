#!/bin/bash
##############
# This is the removal script for the tempadmin.sh script. 
# It will remove the user from the admin group. Then
# will disable the plist that calls this script.  
##############

if [[ -f /var/uits/userToRemove ]]; then
	USERNAME=`cat /var/uits/userToRemove`
	echo "removing" $USERNAME "from admin group"
	/usr/sbin/dseditgroup -o edit -d $USERNAME -t user admin
	echo $USERNAME "has been removed from admin group"
	rm -f /var/uits/userToRemove
else
	defaults write /Library/LaunchDaemons/com.yourcompany.adminremove.plist disabled -bool true
	echo "going to unload"
	launchctl unload -w /Library/LaunchDaemons/com.yourcompany.adminremove.plist
	echo "Completed"
	rm -f /Library/LaunchDaemons/com.yourcompany.adminremove.plist
fi
exit 0