#!/bin/zsh

dockitem () {
    if [[ -d "${1}" && "${1: -4}" != ".app" ]]; then TYPE="directory"; else TYPE="file"; fi
    TMPFILE=$( /usr/bin/mktemp )
    echo "<dict><key>GUID</key><integer>-91117049</integer><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file://localhost${1%%/}/</string><key>_CFURLStringType</key><integer>15</integer></dict><key>file-label</key><string>$( /usr/bin/basename "${1}")</string></dict><key>tile-type</key><string>${TYPE}-tile</string></dict>" > "${TMPFILE}"
    echo "${TMPFILE}"
}

APPS_TO_REMOVE=(
  "App Store.app"
  "Calendar.app"
  "Contacts.app"
  "FaceTime.app"
  "iTunes.app"
  "Keynote.app"
  "Launchpad.app"
  "Mail.app"
  "Maps.app"
  "Messages.app"
  "Music.app"
  "News.app"
  "Numbers.app"
  "Pages.app"
  "Podcasts.app"
  "Photo Booth.app"
  "Photos.app"
  "Reminders.app"
  "Siri.app"
  "System Preferences.app"
  "TV.app"
  )

APPS_TO_ADD=(
    "Google Chrome.app"
    "Firefox.app"
    "Discord.app"
    "Discord Canary.app"
    "System Preferences.app"
    "1Password 7.app"
)

for SELECTION in "${APPS_TO_REMOVE[@]}"; do
    echo "Removing ${SELECTION}"
    sudo jamf modifyDock -leaveRunning -file $( dockitem "/Applications/${SELECTION}" ) -remove
done

for SELECTION in "${APPS_TO_ADD[@]}"; do
    if ${SELECTION}="System Preferences.app"
    then
        sudo jamf modifyDock -leaveRunning -file $( dockitem "/System/Applications/${SELECTION}" )
    fi
    echo "Adding ${SELECTION}"
    sudo jamf modifyDock -leaveRunning -file $( dockitem "/Applications/${SELECTION}" ) -beginning
done

killall Dock

# sudo jamf modifyDock -leaveRunning -file $( dockitem "/Applications/Safari.app" ) -remove
# sudo jamf modifyDock -leaveRunning -file $( dockitem "/Applications/Messages.app" ) -remove
# sudo jamf modifyDock -file $( dockitem "/Applications/Google Chrome.app" ) -beginning

# $sudo jamf modifyDock -leaveRunning -file $( dockitem "/Applications/Safari.app" ) -remove
# $sudo jamf modifyDock -leaveRunning -file $( dockitem "/Applications/Google Chrome.app" ) -remove
# $sudo jamf modifyDock -file $( dockitem "/Applications/Slack.app" )