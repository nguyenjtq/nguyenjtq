#!/bin/zsh

currentUser=$(/bin/ls -l /dev/console | /usr/bin/awk '{print $3}')
adminUser="Discord"
defaultUserImage="/Users/Shared/User Icon.png"
defaultAdminImage="/Users/Shared/Admin Icon.pngs"
dscl . delete /Users/"$currentUser" JPEGPhoto
dscl . delete /Users/"$currentUser" Picture
dscl . delete /Users/"$adminUser" JPEGPhoto
dscl . delete /Users/"$adminUser" Picture
userImageMappings='0x0A 0x5C 0x3A 0x2C'
userImageAttributes='dsRecTypeStandard:Users 2 dsAttrTypeStandard:RecordName externalbinary:dsAttrTypeStandard:JPEGPhoto'
declare -r userImageDSImport="$(mktemp /tmp/${currentUser}_dsimport.XXXXXX)"
printf "%s %s \n%s:%s" "${userImageMappings}" "${userImageAttributes}" "${currentUser}" "${defaultUserImage}" >"${userImageDSImport}"
dsimport "${userImageDSImport}" /Local/Default M

diskutil apfs updatePreboot /