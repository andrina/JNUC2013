#!/bin/sh

########################################################################
# Created By: Andrina Kelly, andrina.kelly@bellmedia.ca, Ext 4995
# Creation Date: March 8, 2013
# Last modified: March 8, 2013
#
# Brief Description: Interactive prompt to change disk ownership
#
# Modification History
# March 8 - New Script
########################################################################

OIFS=$IFS
IFS='"'

# Set CocoaDialog Location
CD="/Path/to/CocoaDialog.app/Contents/MacOS/CocoaDialog"

# Get a list of mounted local disks
MOUNTS=`df -l | awk '{for (i=1; i<=NF-8; i++) $i = $(i+8); NF-=8; print}' | tail -n +3 | awk 'BEGIN { FS = "\t" ; q="\"";  OFS = q FS q }{ $1 = $1; print q $0 q }'`

# Dialog to select the disk name and the create $VOLUMENAME variable
rv=($($CD standard-dropdown --title "Disk Name" --text "Choose the name of the disk you wish to ignore ownership for:" --items $MOUNTS --string-output --float --debug))
IFS=$OIFS
VOLUMENAME=`echo $rv | awk '{for (i=1; i<=NF-1; i++) $i = $(i+1); NF-=1; print}'`

# Ignore ownership using variable created above
vsdbutil -d "$VOLUMENAME"

# Dialog to confirm that the hostname was changed and what it was changed to.
tb=`$CD ok-msgbox --text "Disk Ownership Changed!" \
--informative-text "The disk $VOLUMENAME has been set to ignore ownership" \
--no-newline --float`
if [ "$tb" == "1" ]; then
echo "User said OK"
elif [ "$tb" == "2" ]; then
echo "Canceling"
exit
fi