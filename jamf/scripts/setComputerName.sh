#!/bin/sh

# Sources and credits: 
# - https://community.jamf.com/t5/jamf-pro/self-service-get-user-input-with-script/td-p/142402
# - https://github.com/jamf/Provisioning-Workflows/blob/master/Provisioning_Examples/provisioningWithCompNamePrompt.sh
# Script modified based on aforementioned links. First link for using osascript with logic for capturing nil (cancelled), empty (""), and proper user input. Second link for changing the computer name itself.

user=$(ls -l /dev/console | awk '/ / { print $3 }')

computerName=""


##############################
# Validate Response function #
##############################
validateResponse() {
    case "$computerName" in
        "noinput" )
            askInput ;;     # If return of askInput() is blank, "", prompt for input again.
        "cancelled" )
            /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -other_options foo -startlaunchd -windowType hud -description "Cancelled" -icon /Applications/Self\ Service.app/Contents/Resources/Self\ Service.icns & exit 1 ;;   # Jamf Helper popup window confirming cancellation.
        * )
            /usr/local/jamf/bin/jamf setComputerName -name $computerName    # Set ComputerName, HostName, and LocalHostName.
            /usr/local/jamf/bin/jamf recon      # First Recon to set Computer Name.
            /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -other_options foo -startlaunchd -windowType hud -description "Computer name changed to: $computerName" -icon /Applications/Self\ Service.app/Contents/Resources/Self\ Service.icns & ;;    # Jamf Helper popup window confirming computer name change.
    esac
}

#################################
# Promts User For Computer Name #
#################################
askInput() {
computerName=$(sudo -u "$user" /usr/bin/osascript <<ENDofOSAscript
set theTextReturned to "nil"
try
    set theResponse to display dialog "Please enter the name of the computer" with title "Set Computer Name" default answer ""
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

askInput "$user"

exit 0