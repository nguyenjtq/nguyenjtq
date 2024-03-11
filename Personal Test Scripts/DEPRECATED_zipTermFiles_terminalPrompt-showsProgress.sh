#!/usr/bin/env bash

####################################################################################################
#
# Deprecation Reason
#
# This script was meant to zip terminated user folders using the logged in user.
# This script was meant to show the progress of the zip process.
# This script does show progress of the zip, but does not let user choose output destination.
# Ultimately settled with using `zipUserFolder_promptOutputLocation.sh` script which allows for choosing output destination + zip progress.
#
####################################################################################################

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
        else
            return theTextReturned
        end if
ENDofOSAscript
    )
    validateResponse "$userFolder"
}


########
# MAIN #
########

askInput "$loggedInUser"

exit 0