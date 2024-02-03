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
        --initiate variable
        set theTextReturned to "nil"
        --have user choose which user folder to back up
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
    ## Exit script if userFolder prompt is cancelled
    if [ "$userFolder" == "cancelled" ]; then
        /usr/bin/osascript -e "display dialog \"Zip cancelled\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\""
        exit 0
    fi

    ## Prompt to choose destination location.
    ## Use either ~/Desktop or External Volume. If External Volume, list /Volumes folder and choose.
    outputFolder=$(sudo -u "$loggedInUser" /usr/bin/osascript <<EOF
        --initiate variable
        set chosenVolume to "nil"
        --have user choose between local desktop or external volume
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
        --essentially if chosenVolume == "External Volume", list and choose among /Volumes
        else
            set chosenVolume to "nil"
            try
                tell app "System Events"
                    activate
                    set theResponse to choose from list (list folder "/Volumes") with title "Output Destination" with prompt "Choose an output destination"
                    set chosenVolume to the item 1 of theResponse
                end tell
            end try
            if chosenVolume is "nil" then
                return "cancelled"
            else
                return chosenVolume
            end if
        end if
EOF
    )
    ## Exit script if outputFolder prompt is cancelled
    if [ "$outputFolder" == "cancelled" ]; then
        /usr/bin/osascript -e "display dialog \"Zip cancelled\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\""
        exit 0
    fi
    case "$outputFolder" in
        ## If output folder is "Desktop", check local disk utilization. Cancel or continue script accordingly.
        "~/Desktop" )
            ## If disk utilization >= 50%, prompt for yes/no to continue or cancel.
            if [ "$intDiskCap" -ge "50" ]; then
                button=$(/usr/bin/osascript -e "display dialog \"Zipping to the local disk with disk usage at $diskCap may result in an error. You may need a formatted (exFAT, FAT32, APFS) external drive with sufficient storage. Continue anyways?.\" with title \"$orgName Self Service\" buttons {\"No\", \"Yes\"} default button 1 with icon POSIX file \"$brandIcon\"")
            fi
            ## If no, cancel and exit script.
            if [ "$button" == "button returned:No" ]; then
                /usr/bin/osascript -e "display dialog \"Zip cancelled\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\""
                exit 0
            ## If yes, continue with script, though depending on utilization, this may result in `zip I/O error: no space left on device` error by `zip` command.
            else
                ## Output file location
                zipSaveLocation="/Users/$loggedInUser/Desktop/$(date '+%Y-%m-%d-%H.%M.%S')_$userFolder-$serialNumber.zip"
                
                ## Display zipping dialog
                /usr/bin/osascript -e "display dialog \"Zipping '$userFolder'. Output file: \n\n$zipSaveLocation\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\"" &\

                ## Bring Terminal to foreground, run zip of chosen folder, open Finder to save location when done. Uses `osascript` to run Terminal as local user.
                /usr/bin/osascript -e "tell application \"Terminal\" to activate" -e "tell application \"Terminal\" to do script \"sudo zip -ryv '$zipSaveLocation' '/Users/$userFolder' -x '/Users/$userFolder/Library/*' && open -R '$zipSaveLocation'\""
            fi
            ;;
        ## Use "/Volumes" path as destination.
        * )
            ## Output file location
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