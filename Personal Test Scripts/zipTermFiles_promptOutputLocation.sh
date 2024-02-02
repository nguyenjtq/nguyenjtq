#!/usr/bin/env bash

#################
# Set variables #
#################
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

## Computer Serial Number
serialNumber=$(system_profiler SPHardwareDataType | grep Serial |  awk '{print $NF}')

## Disk capacity
diskCap=$(df -Ph . | tail -1 | awk '{print $5}')
intDiskCap="${diskCap//%}"


#####################################
# Prompts User For Folder to Backup #
#####################################
askInput() {
    userFolder=$(sudo -u "$loggedInUser" /usr/bin/osascript <<EOF
        set theTextReturned to "nil"
        try
            tell app "System Events"
                activate
                set theResponse to choose from list (list folder "/Users") with title "Backing Up" with prompt "Choose a folder to zip"
                set theTextReturned to the item 1 of theResponse
            end tell
        end try
        if theTextReturned is "nil" then
            return "cancelled"
        else
            return theTextReturned
        end if
EOF
    )
    if [ "$userFolder" == "cancelled" ]; then
        /usr/bin/osascript -e "display dialog \"Zip cancelled\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\""
        exit 0
    fi

    outputFolder=$(sudo -u "$loggedInUser" /usr/bin/osascript <<EOF
        set chosenVolume to "nil"
        try
            tell app "System Events"
                activate
                set theResponse to choose from list {"~/Desktop", "External Volume"} with title "Output Destination" with prompt "Choose an output destination"
                set chosenVolume to the item 1 of theResponse
            end tell
        end try
        if chosenVolume is "nil" then
            return "cancelled"
        else if chosenVolume is "~/Desktop" then
            return chosenVolume
        else
            try
                tell app "System Events"
                    activate
                    set theResponse to choose from list (list folder "/Volumes") with title "Output Destination" with prompt "Choose an output destination"
                    set chosenVolume to the item 1 of theResponse
                end tell
            end try
            return chosenVolume
        end if
EOF
    )
    if [ "$outputFolder" == "cancelled" ]; then
        /usr/bin/osascript -e "display dialog \"Zip cancelled\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\""
        exit 0
    fi
    
    case "$outputFolder" in
        "~/Desktop" )
            if [ "$intDiskCap" -le "50" ]; then
                /usr/bin/osascript -e "display dialog \"Disk usage is $diskCap, you will need a formatted (exFAT, FAT32, APFS) external drive with sufficient storage. Plug one in and restart the process.\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\""
                exit 0
            else
                ## Output file location
                zipSaveLocation="/Users/$loggedInUser/Desktop/$(date '+%Y-%m-%d-%H.%M.%S')_$userFolder-$serialNumber.zip"
                
                ## Display zipping dialog
                /usr/bin/osascript -e "display dialog \"Zipping '$userFolder'. Output file: \n\n$zipSaveLocation\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\"" &\

                ## Bring Terminal to foreground, run zip of chosen folder, open Finder to save location when done. Uses `osascript` to run Terminal as local user.
                /usr/bin/osascript -e "tell application \"Terminal\" to activate" -e "tell application \"Terminal\" to do script \"sudo zip -ryv '$zipSaveLocation' '/Users/$userFolder' -x '/Users/$userFolder/Library/*' && open -R '$zipSaveLocation'\""
            fi
            ;;
        * )
            zipSaveLocation="/Volumes/$outputFolder/$(date '+%Y-%m-%d-%H.%M.%S')_$userFolder-$serialNumber.zip"
            
            ## Display zipping dialog
            /usr/bin/osascript -e "display dialog \"Zipping '$userFolder'. Output file: \n\n$zipSaveLocation\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\"" &\

            ## Bring Terminal to foreground, run zip of chosen folder, open Finder to save location when done. Uses `osascript` to run Terminal as local user.
            /usr/bin/osascript -e "tell application \"Terminal\" to activate" -e "tell application \"Terminal\" to do script \"sudo zip -ryv '$zipSaveLocation' '/Users/$userFolder' -x '/Users/$userFolder/Library/*' && open -R '$zipSaveLocation'\""
    esac
}

########
# MAIN #
########

askInput "$loggedInUser"

exit 0