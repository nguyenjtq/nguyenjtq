#!/bin/bash

# Credit: https://github.com/kcrawford/dockutil

/usr/local/bin/dockutil --remove all

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
        /usr/local/bin/dockutil --add /Applications/"${SELECTION}" --allhomes
    fi
    if [ -e /System/Applications/"${SELECTION}" ]; then
        /usr/local/bin/dockutil --add /System/Applications/"${SELECTION}" --allhomes
    fi
done

exit 0