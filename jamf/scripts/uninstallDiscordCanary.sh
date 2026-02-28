#!/usr/bin/env bash

appName="Discord Canary"
appLocation="/Applications/Discord Canary.app"
userAppSupport="$HOME/Library/Application Support/discordcanary"
appSupport="/Library/Application Support/discordcanary"
cache1="$HOME/Library/Caches/com.hnc.DiscordCanary"
cache2="$HOME/Library/Caches/com.hnc.DiscordCanary.ShipIt"

printf "\nCHECK FOR %s INSTALLATION\n\n" "$appName"

# kill app if running
echo "Closing $appName"
pkill -2 "$appName"
sleep 5

# check for app
if [ -d "$appLocation" ]; then
    echo "$appName present. Removing: ($appLocation)"
    sudo /bin/rm -rfd "$appLocation"
else
    echo "$appName not present on system!"
fi

# check for user Application Support
if [ -d "$userAppSupport" ]; then
    echo "$appName user application support folder present. Removing: ($userAppSupport)."
    sudo /bin/rm -rfd "$userAppSupport"
else
    echo "$appName user application support folder not present on system!"
fi

# check for Application Support
if [ -d "$appSupport" ]; then
    echo "$appName application support folder present. Removing: ($appSupport)."
    sudo /bin/rm -rfd "$appSupport"
else
    echo "$appName application support folder not present on system!"
fi

# check for cache
if [ -d "$cache1" ]; then
    echo "$appName cache folder present. Removing: ($cache1)."
    sudo /bin/rm -rfd "$cache1"
else
    echo "$appName cache folder not present on system!"
fi

if [ -d "$cache2" ]; then
    echo "$appName cache folder present. Removing: ($cache2)."
    sudo /bin/rm -rfd "$cache2"
else
    echo "$appName cache folder not present on system!"
fi