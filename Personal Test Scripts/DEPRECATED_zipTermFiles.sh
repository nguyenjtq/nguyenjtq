#!/usr/bin/env zsh

####################################################################################################
#
# Deprecation Reason
#
# This script was meant to zip terminated user folders.
# This script required manually entering the user folder to zip.
# This script did not allow choosing output destination.
# Opted for `zipUserFolder_promptOutputLocation.sh`.
#
####################################################################################################

## Get current user
loggedInUser=$(/usr/bin/stat -f %Su /dev/console)

echo "Logged in as $loggedInUser"
echo "Enter the user home folder name to back up:"
read "userFolder"
zipSaveLocation="/Users/$loggedInUser/Desktop/$(date '+%Y-%m-%d-%H.%M.%S')_$userFolder.zip"


sudo zip -ryv $zipSaveLocation "/Users/$userFolder" -x "/Users/$userFolder/Library/*" -x "/Users/$userFolder/*/.*" -x "/Users/$userFolder/.*"