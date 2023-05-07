#!/usr/bin/env zsh

# Get current user
loggedInUser=$(/usr/bin/stat -f %Su /dev/console)

# Oracle Java paths to remove
javaAppletPlugin="/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin"
javaControlPanel="/Library/PreferencePanes/JavaControlPanel.prefPane"
javaApplicationSupport="/Users/$loggedInUser/Library/Application\ Support/Oracle/Java"

# Oracle JDK Location
javaJDK="/Library/Java/JavaVirtualMachines"

echo "\nChecking for and removing Oracle Java folders\n"
for stuff in $javaAppletPlugin $javaControlPanel $javaApplicationSupport; do
    if [[ -d $stuff ]]; then
        echo "Removing $stuff"
        # rm -rf $stuff
    else
        echo "$stuff not found"
    fi
done

echo "\nChecking for and removing Oracle JDK folders\n"
for stuff in $(find $javaJDK -type d -iname "jdk1.*"); do
    echo "Removing $stuff"
    # rm -rf $stuff
done