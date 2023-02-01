#!/usr/bin/env zsh

# Get current user
loggedInUser=$(/usr/bin/stat -f %Su /dev/console)

# Log paths
jamfLog="/var/log/jamf.log"
installLog="/var/log/install.log"
systemLog="/var/log/system.log"
selfServiceLog="/Users/$loggedInUser/Library/Logs/Jamf/selfservice_debug.log"

# Logs save location
logSaveLocation="/Users/$loggedInUser/Desktop/Jamf Logs"

# Enable Self Service Debug logs
defaults write /Users/$loggedInUser/Library/Preferences/com.jamfsoftware.selfservice debug_mode -boolean YES
echo "Self Service debugging mode enabled. Recreate issue."
echo "Press ENTER to continue..."
while [[ true ]]
do
    read -n 1
    if [[ $? = 0 ]] ; then 
        echo "Continuing"
        break
    else
        echo "Waiting"
    fi
done

# Make log save location on desktop and copy corresponding logs
mkdir $logSaveLocation
echo "Making directory $logSaveLocation\n"
cp -v $jamfLog $installLog $systemLog $selfServiceLog /Users/$loggedInUser/Desktop/Jamf\ Logs
echo "Log files copied to $logSaveLocation.\n"
rm /Users/$loggedInUser/Library/Preferences/com.jamfsoftware.selfservice.plist
echo "Disabling Self Service debugging mode.\n"

# Generate SysDiagnose file
echo "Do you need to generate a SysDiagnose file? [y/n]"
while [[ true ]]
do
    read response
    if [[ $response = y ]] ; then 
        echo "Creating SysDiagnose file at $logSaveLocation"
        # sudo sysdiagnose -f $logSaveLocation
        break
    elif [[ $response = n ]] ; then
        echo "No SysDiagnose file generated. Exiting..."
        exit
    else
        echo "Wrong key entered. Enter [y/n] to proceed."
    fi
done