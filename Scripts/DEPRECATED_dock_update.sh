#!/usr/bin/bash

## Cleanup Dock
#------------------------------------

# Get The utility to manipulate the Dock
echo -e "\nCleaning up Dock Items\n"
cd /tmp
curl -fsSLO "https://github.com/kcrawford/dockutil/raw/master/scripts/dockutil"

# Delete Existing Dock Items
APPS_TO_REMOVE=(
  "App Store"
  "Calendar"
  "Contacts"
  "FaceTime"
  "iTunes"
  "Keynote"
  "Launchpad"
  "Mail"
  "Maps"
  "Messages"
  "Music"
  "News"
  "Numbers"
  "Report Phishing"
  "Pages"
  "Podcasts"
  "Photo Booth"
  "Photos"
  "Reminders"
  "Siri"
  "System Preferences"
  "TV"
  )

for SELECTION in "${APPS_TO_REMOVE[@]}"; do
  echo "Removing ${SELECTION}"
  python dockutil --remove "${SELECTION}"
done

# # Add New Dock Items
APPS_TO_ADD=(
    "Google Chrome.app"
    "Firefox.app"
    "Discord.app"
    "Discord Canary.app"
    "System Preferences.app"
    "1Password 7.app"
)

for SELECTION in "${APPS_TO_ADD[@]}"; do
    if [ -e /Applications/"${SELECTION}" ]; then
        echo "Adding ${SELECTION}"
        python dockutil --add /Applications/"${SELECTION}" --after 'Finder'
    fi
    if [ -e /System/Applications/"${SELECTION}" ]; then
        echo "Adding ${SELECTION}"
        python dockutil --add /System/Applications/"${SELECTION}" --after 'Finder'
    fi
done

## SCRIPT DONE
#--------------------------------------------------------------------

echo -e "\n\nDock apps updated!!\n\n"