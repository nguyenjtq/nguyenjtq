#!/usr/bin/env bash

## Get the logged in user's username
userName=$(/usr/bin/stat -f%Su /dev/console)

## $4 = "Discord" (Company Name)
## $6 = "Please submit a WotW ticket or reach out in #it-team in Discord HQ." (Contact IT Message)
## $7 = /path/to/icon (Typically, this is empty and defaults to the jam icon)

selfServiceBrandIcon="/Users/$userName/Library/Application Support/com.jamfsoftware.selfservice.mac/Documents/Images/brandingimage.png"
jamfBrandIcon="/Library/Application Support/JAMF/Jamf.app/Contents/Resources/AppIcon.icns"

if [[ -n "$4" ]]; then
    orgName="$4 -"
fi

if [[ -n "$6" ]]; then
    haltMsg="$6"
else
    haltMsg="Please contact IT for further assistance."
fi

if [[ -n "$7" ]]; then
    brandIcon="$7"
elif [[ -f $selfServiceBrandIcon ]]; then
    brandIcon=$selfServiceBrandIcon
elif [[ -f $jamfBrandIcon ]]; then
    brandIcon=$jamfBrandIcon
fi

## Oracle Java paths to remove
javaAppletPlugin="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin"
javaControlPanel="/Library/PreferencePanes/JavaControlPanel.prefPane"
javaApplicationSupport="/Users/$userName/Library/Application Support/Oracle/Java"
_temp=("$javaAppletPlugin" "$javaControlPanel" "$javaApplicationSupport")

## Oracle JDK Location
javaJDK="/Library/Java/JavaVirtualMachines"

## Loops through and Oracle Java paths and determines if files/folders exist.
printf "\nChecking for Oracle Java folder...\n\n"
oracleJava=()
for stuff in "${_temp[@]}"; do
    if [[ -e "$stuff" ]]; then
        oracleJava+=("$stuff")
    fi
done

## Echos if Oracle Java files / folders were found.
if [[ -z ${oracleJava[*]} ]]; then
    echo "No Oracle Java files found."
else
    for file in "${oracleJava[@]}"; do
        echo "Found \"$file\""
    done
fi

## Searches for known Java JDK folders and gathers them in an array.
printf "\nChecking for Oracle JDK folders...\n\n"
mapfile -t jdkFilesFound < <(find "$javaJDK" -type d -iname "jdk1.*")

## Echos if Oracle JDK files / folders were found.
if [[ -z ${jdkFilesFound[*]} ]]; then
    echo "No Java JDK files found."
else
    for file in "${jdkFilesFound[@]}"; do
        echo "Found \"$file\""
    done
fi

## [TO BE ADDED] `osascript` prompt that takes returned "Yes/No" and removes / doesn't remove Java files.
## refer to "setComputerName.sh" script

/usr/bin/osascript -e "display dialog \"Howdy, Partner! Looks like you have the Oracle JDK installed:\n $(for i in "${jdkFilesFound[@]}"; do echo $i; done)\" with title \"$orgName Self Service\" buttons {\"Yeet\"} default button 1 with icon POSIX file \"$brandIcon\""