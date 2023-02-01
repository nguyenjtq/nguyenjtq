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

## Logs save location
logSaveLocation="/Users/$loggedInUser/Desktop"

## Computer Serial Number
serialNumber=$(system_profiler SPHardwareDataType | grep Serial |  awk '{print $NF}')

## Display a dialog that the action started
/usr/bin/osascript -e "display dialog \"Sysdiagnose started. Please wait a few minutes for it to finish.\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\""
echo "Sysdiagnose started."

## Run the sysdiagnose
/usr/bin/sysdiagnose -u -f $logSaveLocation -A "sysdiagnose_$serialNumber"_"$(date '+%Y-%m-%d-%H.%M.%S')"

## Display a dialog that the action is complete
/usr/bin/osascript -e "display dialog \"Sysdiagnose finished.\" & return & \"Please check your Desktop folder for the file.\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\""

## Open file location
open $logSaveLocation