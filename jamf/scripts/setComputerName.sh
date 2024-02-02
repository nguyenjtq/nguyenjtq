#!/usr/bin/env zsh

# Sources and credits: 
# - https://community.jamf.com/t5/jamf-pro/self-service-get-user-input-with-script/td-p/142402
# - https://github.com/jamf/Provisioning-Workflows/blob/master/Provisioning_Examples/provisioningWithCompNamePrompt.sh
# Script modified based on aforementioned links. First link for using osascript with logic for capturing nil (cancelled), empty (""), and proper user input. Second link for changing the computer name itself.

# Parameter 4 = Set organization name in pop up window
# Parameter 5 = Failed Attempts until Stop
# Parameter 6 = Custom text for contact information.
# Parameter 7 = Custom Branding - Defaults to Self Service Icon

## Customizes Prompt Window
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

## Get logged in user using the `stat` command
loggedInUser=$(/usr/bin/stat -f %Su /dev/console)

computerName=""

##############################
# Validate Response function #
##############################
validateResponse() {
    case "$computerName" in
        "noinput" )
            askInput ;;     # If return of askInput() is blank, "", prompt for input again.
        "cancelled" )
            /usr/bin/osascript -e "display dialog \"Computer name change cancelled.\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\"" ;; # Displays "cancelled" prompt.
        * )
            /usr/local/jamf/bin/jamf setComputerName -name $computerName    # Set ComputerName, HostName, and LocalHostName.
            /usr/local/jamf/bin/jamf recon      # First Recon to set Computer Name.
            /usr/bin/osascript -e "display dialog \"Computer name changed to: $computerName\" with title \"$orgName Self Service\" buttons {\"Close\"} default button 1 with icon POSIX file \"$brandIcon\""    # Displays successful computer name change prompt.
    esac
}

#################################
# Prompts User For Computer Name #
#################################
askInput() {
computerName=$(sudo -u "$loggedInUser" /usr/bin/osascript <<ENDofOSAscript
set theTextReturned to "nil"
try
    set theResponse to display dialog "Please enter the computer name" with title "Set Computer Name" default answer "" with icon POSIX file "$brandIcon"
    set theTextReturned to the text returned of theResponse
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
validateResponse "$computerName"
}

askInput "$loggedInUser"

exit 0