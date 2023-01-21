#!/usr/bin/env zsh

selfServiceBrandIcon="/Users/$3/Library/Application Support/com.jamfsoftware.selfservice.mac/Documents/Images/brandingimage.png"
jamfBrandIcon="/Library/Application Support/JAMF/Jamf.app/Contents/Resources/AppIcon.icns"

if [ ! -z "$4" ]; then
    orgName="$4 -"
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

## Log paths
jamfLog="/var/log/jamf.log"
installLog="/var/log/install.log"
systemLog="/var/log/system.log"
selfServiceLog="/Users/$loggedInUser/Library/Logs/Jamf/selfservice_debug.log"

## Computer Serial Number
serialNumber=$(system_profiler SPHardwareDataType | grep Serial |  awk '{print $NF}')

## Logs save location
logSaveLocation="/Users/$loggedInUser/Desktop/$serialNumber"_"$(date '+%Y-%m-%d-%H.%M.%S')_JamfLogs.zip"

## Zip corresponding log files and save them to the desktop
zip -jr $logSaveLocation $jamfLog $installLog $systemLog $selfServiceLog
echo "Log zipped to $logSaveLocation"

## Display a dialog that the action is complete
/usr/bin/osascript -e "display dialog \"Jamf logs zipped.\" & return & \"Please check your Desktop folder.\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\""

## Open file location
open -R $logSaveLocation