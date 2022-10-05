#!/bin/sh

merakiSM="com.meraki.sm.mdm"
launch_daemon="/Library/LaunchDaemons/com.meraki.agentd.plist"
agent="/Library/Application Support/Meraki/m_agent /Library/Application Support/Meraki/m_agent_upgrade"
app_directory="/Library/Application Support/Meraki/"

echo "\nCHECK FOR CISCO MERAKI INSTALLATION"

# check for Meraki Systems Manager configuration profile
if [ $(/usr/bin/profiles -L | grep -io "$merakiSM")=$merakiSM ]; then
    echo "Meraki Systems Manager configuration profile present: ($merakiSM)."
    echo "Removing ($merakiSM)."
    /usr/bin/profiles -R -p com.meraki.sm.mdm
else
    echo "Meraki Systems Manager configuration profile not present on system!"
fi

# check for launch daemon
if [ -f "$launch_daemon" ]; then
    echo "Cisco Meraki launch daemon present: ($launch_daemon)"
    echo "Removing ($launch_daemon)."
    launchctl unload $launch_daemon
    /bin/rm -f $launch_daemon
else
    echo "Cisco Meraki launch daemon not present on system!"
fi

# check for agent
if [ -f "$agent" ]; then
    echo "Cisco Meraki agent present: ($agent)."
    echo "Removing ($agent)."
    /bin/rm -f $agent
else
    echo "Cisco Meraki agent not present on system!"
fi

# check for app directory
if [ -f "$app_directory" ]; then
    echo "Cisco Meraki app directory present: ($app_directory)"
    echo "Removing ($app_directory)."
    /bin/rm -f $app_directory
else
    echo "Cisco Meraki app directory not present on system!"
fi

# renew enrollment
sleep 5
/usr/bin/profiles renew -type enrollment