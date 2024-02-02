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


##############################
# Validate Response function #
##############################
validateResponse() {
    case "$userFolder" in
        # If return of askInput() is blank, "", prompt for input again
        "noinput" )
            askInput ;;
        # Displays "cancelled" prompt
        "cancelled" )
            /usr/bin/osascript -e "display dialog \"Zip cancelled\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\"" ;;
        * )
            ## Output file location
            zipSaveLocation="/Users/$loggedInUser/Desktop/$(date '+%Y-%m-%d-%H.%M.%S')_$userFolder-$serialNumber.zip"
            
            ## Display zipping dialog
            /usr/bin/osascript -e "display dialog \"Zipping $userFolder. Output file will be in the desktop folder.\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\"" &\

            ## Bring Terminal to foreground, run zip of chosen folder, open Finder to save location when done. Uses `osascript` to run Terminal as local user.
            /usr/bin/osascript -e "tell application \"Terminal\" to activate" -e "tell application \"Terminal\" to do script \"sudo zip -ryv '$zipSaveLocation' '/Users/$userFolder' -x '/Users/$userFolder/Library/*' && open -R '$zipSaveLocation'\""

            ## SHOULD I CAFFEINATE THIS ^^^^^?
            ## would look something like
            # /usr/bin/osascript -e "tell application \"Terminal\" to activate" -e "tell application \"Terminal\" to do script \"caffeinate -mudsi & (sudo zip -ryv '$zipSaveLocation' '/Users/$userFolder' -x '/Users/$userFolder/Library/*' && open -R '$zipSaveLocation')\""

            ## Do not copy `~/Library` and any `.*` files, so any files that start with a period. Those files are hidden files.
            # & zip -ryv "$zipSaveLocation" "/Users/$userFolder" -x "/Users/$userFolder/Library/*" -x "/Users/$userFolder/*/.*" -x "/Users/$userFolder/.*"
    esac
}


#####################################
# Prompts User For Folder to Backup #
#####################################
askInput() {
    userFolder=$(sudo -u "$loggedInUser" /usr/bin/osascript <<ENDofOSAscript
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
        else if theTextReturned is "" then
            return "noinput"
        else
            return theTextReturned
        end if
ENDofOSAscript
    )
    validateResponse "$userFolder"
}

###################################
# [TBD] CALCULATE AVAILABLE SPACE #
###################################
## [Calculate space availability for zip]
    # [throw error if not enough space]
        # [provide option to use external storage and prompt for external storage option]
            # [somehow provide a list to choose for potential storage options]
    # [proceed if enough space]

########
# MAIN #
########

if [ "$intDiskCap" -ge "50" ]; then
    /usr/bin/osascript -e "display dialog \"Disk usage is $diskCap, you will need an external drive.\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\""
else
    askInput "$loggedInUser"
fi

exit 0