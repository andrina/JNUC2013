#!/bin/bash

########################################################################
# Created By: Andrina Kelly, andrina.kelly@bellmedia.ca, Ext 4995
# Creation Date: July 2013
# Last modified: July 25th, 2013
# Brief Description: Deletes the users login.keychain, and creates a new keychain
########################################################################

# Set CocoaDialog Location
CD="/Path/to/CocoaDialog.app/Contents/MacOS/CocoaDialog"

#Find out who's logged in
USER=`who | grep console | awk '{print $1}'`

#Get the name of the users keychain - some messy sed and awk to set up the correct name for security to like
KEYCHAIN=`su $USER -c "security list-keychains" | grep login | sed -e 's/\"//g' | sed -e 's/\// /g' | awk '{print $NF}'`

#Go delete the keychain in question...
su $USER -c "security delete-keychain $KEYCHAIN"

#Ask the user for their login password to create a new keychain
rv=($($CD secure-standard-inputbox --title "Set New Keychain Password" --no-newline --informative-text "Enter your current login password"))
PASSWORD=${rv[1]}

#Create the new login keychain
expect <<- DONE
  set timeout -1
  spawn su $USER -c "security create-keychain login.keychain"

  # Look for  prompt
  expect "*?chain:*"
  # send user entered password from CocoaDialog
  send "$PASSWORD\n"
  expect "*?chain:*"
  send "$PASSWORD\r"
  expect EOF
DONE

#Set the newly created login.keychain as the users default keychain
su $USER -c "security default-keychain -s login.keychain"