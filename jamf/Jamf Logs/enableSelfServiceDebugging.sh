#!/usr/bin/env zsh

selfServiceBrandIcon="/Users/$3/Library/Application Support/com.jamfsoftware.selfservice.mac/Documents/Images/brandingimage.png"
jamfBrandIcon="/Library/Application Support/JAMF/Jamf.app/Contents/Resources/AppIcon.icns"

if [ ! -z "$4" ]; then
    orgName="$4"
fi

if [ ! -z "$6" ]; then
    haltMsg="$6"
else
    haltMsg="Please contact IT for further assistance."
fi

if [[ ! -z "$7" ]]; then
    brandIcon="$7"
elif [[ -f $selfServiceBrandIcon ]]; then
    brandIcon=$selfServiceBrandIcon
elif [[ -f $jamfBrandIcon ]]; then
    brandIcon=$jamfBrandIcon
fi

## Get current user
loggedInUser=$(/usr/bin/stat -f %Su /dev/console)

## Enable Self Service Debug logs
defaults write /Users/$loggedInUser/Library/Preferences/com.jamfsoftware.selfservice debug_mode -boolean YES
echo "Self Service debugging mode enabled."

## Display a dialog that the action is complete
/usr/bin/osascript -e "display dialog \"Self Service debug mode enabled\" & return & return & \"Disable Self Service debug mode when finished.\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\""