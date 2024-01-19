#!/usr/bin/env bash

## Get the logged in user's name
userName=$(/usr/bin/stat -f%Su /dev/console)

## $4 = "Discord" (Company Name)
## $6 = "Please submit a WotW ticket or reach out in #it-team in Discord HQ." (Contact IT Message)
## $7 = /path/to/icon (Typically, this is empty and defaults to the jam icon)

selfServiceBrandIcon="/Users/$userName/Library/Application Support/com.jamfsoftware.selfservice.mac/Documents/Images/brandingimage.png"
jamfBrandIcon="/Library/Application Support/JAMF/Jamf.app/Contents/Resources/AppIcon.icns"

if [[ -n "$4" ]]; then
    orgName="$4 -"
fi

if [[ -n "$6" ]]; then
    haltMsg="$6"
else
    haltMsg="Please contact IT for further assistance."
fi

if [[ -n "$7" ]]; then
    brandIcon="$7"
elif [[ -f $selfServiceBrandIcon ]]; then
    brandIcon=$selfServiceBrandIcon
elif [[ -f $jamfBrandIcon ]]; then
    brandIcon=$jamfBrandIcon
fi


/usr/bin/osascript -e "display dialog \"Howdy, Partner! Looks like you haven't returned your old laptop. How about we giddy along with that!\" with title \"$orgName Self Service\" buttons {\"Yeet\"} default button 1 with icon POSIX file \"$brandIcon\""