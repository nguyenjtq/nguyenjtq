#!/bin/bash

# Credit: https://macadmins.slack.com/archives/C04QVP86E/p1661970182385409?thread_ts=1661964546.908799&cid=C04QVP86E

username=$(/usr/bin/defaults read /Library/Preferences/com.apple.loginwindow lastUserName)

set -e

declare -x USERNAME=$username
declare -x USERPIC="/Users/Shared/User Icon.png"
# if [[ $USERNAME == "Discord" ]]
# then
#     declare -x USERPIC="/Users/Shared/Admin Icon.png"
# else
#     declare -x USERPIC="/Users/Shared/User Icon.png"
# fi

declare -r DSIMPORT_CMD="/usr/bin/dsimport"
declare -r ID_CMD="/usr/bin/id"

declare -r MAPPINGS='0x0A 0x5C 0x3A 0x2C'
declare -r ATTRS='dsRecTypeStandard:Users 2 dsAttrTypeStandard:RecordName externalbinary:dsAttrTypeStandard:JPEGPhoto'

if [ ! -f "${USERPIC}" ]; then
  echo "User image required"
fi

# Check that the username exists - exit on error
${ID_CMD} "${USERNAME}" &>/dev/null || ( echo "User does not exist" && exit 1 )

declare -r PICIMPORT="$(mktemp /tmp/${USERNAME}_dsimport.XXXXXX)" || exit 1
printf "%s %s \n%s:%s" "${MAPPINGS}" "${ATTRS}" "${USERNAME}" "${USERPIC}" >"${PICIMPORT}"
${DSIMPORT_CMD} "${PICIMPORT}" /Local/Default M &&
    echo "Successfully imported ${USERPIC} for ${USERNAME}."

rm "${PICIMPORT}"