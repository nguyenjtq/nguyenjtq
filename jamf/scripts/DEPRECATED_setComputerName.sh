#!/bin/sh

#################################
# Promts User For Computer Name #
#################################
user=$(ls -l /dev/console | awk '/ / { print $3 }')
computerName=$(sudo -u $user /usr/bin/osascript <<ENDofOSAscript
set T to text returned of (display dialog "Please enter the name of the computer." buttons {"OK"} default button "OK" default answer "")
ENDofOSAscript
)

###################################
# Sets local computer to new name #
###################################
/usr/local/jamf/bin/jamf setComputerName -name $computerName    # This is functionally the same as using `scutil` in the below three commands.
# /usr/sbin/scutil --set HostName $computerName
# /usr/sbin/scutil --set ComputerName $computerName
# /usr/sbin/scutil --set LocalHostName $computerName

####################################
# First Recon to set Computer Name #
####################################
/bin/echo "Running recon"
/usr/local/jamf/bin/jamf recon

##############################
# Jamf Helper Popup Window 1 #
##############################
/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -other_options foo -startlaunchd -windowType hud -description "Changed computer name to: $computerName" -icon /Applications/Self\ Service.app/Contents/Resources/Self\ Service.icns &