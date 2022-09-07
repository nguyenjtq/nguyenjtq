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
/usr/sbin/scutil --set HostName $computerName
/usr/sbin/scutil --set ComputerName $computerName
/usr/sbin/scutil --set LocalHostName $computerName

####################################
# First Recon to set Computer Name #
####################################
/bin/echo "Running recon"
/usr/local/jamf/bin/jamf recon

/bin/echo "Changed computer names to: $computerName"