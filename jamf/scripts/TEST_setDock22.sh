#!/bin/zsh

dockutilbin=$(/usr/bin/which dockutil)
loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
loggedInUserPlist="/Users/$loggedInUser/Library/Preferences/com.apple.dock.plist"

$dockutilbin --remove all --no-restart $loggedInUserPlist; sleep 2

APPS_TO_ADD=(
    "Google Chrome.app"
    "Discord.app"
    "Discord Canary.app"
    "1Password 7.app"
    "System Preferences.app"
    "Discord Self Service.app"
)

for SELECTION in "${APPS_TO_ADD[@]}"; do
    if [ -e /Applications/"${SELECTION}" ]; then
        $dockutilbin --add file:///Applications/"${SELECTION}"/ --no-restart $loggedInUserPlist
    fi
    if [ -e /System/Applications/"${SELECTION}" ]; then
        $dockutilbin --add file:///System/Applications/"${SELECTION}"/ --no-restart $loggedInUserPlist
    fi
done

# $dockutilbin --add file:///System/Applications/Launchpad.app/ --no-restart $loggedInUserPlist
# $dockutilbin --add file:///Applications/Safari.app/ --no-restart $loggedInUserPlist
# $dockutilbin --add file:///System/Applications/Calendar.app/ --no-restart $loggedInUserPlist
# $dockutilbin --add file:///System/Applications/Dictionary.app/ --no-restart $loggedInUserPlist
# $dockutilbin --add file:///Applications/Microsoft\ Word.app/ --no-restart $loggedInUserPlist
# $dockutilbin --add file:///Applications/Microsoft\ Excel.app/ --no-restart $loggedInUserPlist
# $dockutilbin --add file:///Applications/Microsoft\ PowerPoint.app/ --no-restart $loggedInUserPlist
# $dockutilbin --add file:///Applications/Microsoft\ OneNote.app/ --no-restart $loggedInUserPlist
# $dockutilbin --add file:///Applications/Self\ Service.app/ --no-restart $loggedInUserPlist
# $dockutilbin --add file:///Applications/PCClient.app/ --label Papercut --no-restart $loggedInUserPlist
# $dockutilbin --add file:///System/Applications/System\ Preferences.app/ --no-restart $loggedInUserPlist
# $dockutilbin --add '/Applications/' --view grid --display folder --sort name --no-restart $loggedInUserPlist
# $dockutilbin --add '~/Downloads/' --view fan --display folder --sort name $loggedInUserPlist

exit 0