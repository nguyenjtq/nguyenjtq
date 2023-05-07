#!/usr/bin/env zsh

## Get current user
loggedInUser=$(/usr/bin/stat -f %Su /dev/console)

## Profile picture paths
userProfilePic="/Users/Shared/User Icon.png"
adminProfilePic="/Users/Shared/Admin Icon.png"

## Checks if user and admin profile pictures exist
if [[ -f $userProfilePic && -f $adminProfilePic ]]; then
    echo "User profile picture exists, proceeding..."
    
    ## Deletes the logged in user's existing profile picture
    /usr/bin/dscl . delete "/Users/$loggedInUser" JPEGPhoto

    ## Sets profile picture according to who is logged in.
    if [[ $loggedInUser == "discord" ]]; then
        /usr/bin/dscl . create "/Users/$loggedInUser" Picture "$adminProfilePic"
    else
        /usr/bin/dscl . create "/Users/$loggedInUser" Picture "$userProfilePic"
    fi

    echo "Profile picture successfully set for $loggedInUser."
else
    echo "User profile pictures do not exist.\nConfirm if the following Jamf policy ran successfully: \"Store User Icons and Wallpaper\""
fi