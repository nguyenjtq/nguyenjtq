#!/bin/bash
# NEW DockUtil Script without python v2.2

# Install brew
echo "Installing Homebrew"
if brew --version > /dev/null; then
  echo "Homebrew detected"
else
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install dockutil
fi

# Include Standard PATH for commands
sudo -v
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
# Set up variables
whoami="/usr/bin/whoami"
echo="/bin/echo"
sudo="/usr/bin/sudo"
dockutil="/usr/local/bin/dockutil"
killall="/usr/bin/killall"
loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
LoggedInUserHome="/Users/$loggedInUser"
UserPlist=$LoggedInUserHome/Library/Preferences/com.apple.dock.plist

##########################################################################################
# Check if script is running as root
##########################################################################################
$echo

if [ `$whoami` != root ]; then
    $echo "[ERROR] This script must be run using sudo or as root. Exiting..."
    exit 1
fi

##########################################################################################
# Use Dockutil to Modify Logged-In User's Dock
##########################################################################################
$echo "----------------------------------------------------------------------"
$echo "Dockutil script to modify logged-in user's Dock"
$echo "----------------------------------------------------------------------"
$echo "Current logged-in user: $loggedInUser"
$echo "----------------------------------------------------------------------"
$echo "Removing all Items from the Logged-In User's Dock..."
$sudo -u $loggedInUser $dockutil --remove all --no-restart $UserPlist

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

APPS_TO_ADD=(
    "Google Chrome.app"
    "Firefox.app"
    "Discord.app"
    "Discord Canary.app"
    "System Preferences.app"
    "1Password 7.app"
)

$echo "Creating New Dock..."
$echo

for SELECTION in "${APPS_TO_REMOVE[@]}"; do
  echo "Removing \"${SELECTION}\"..."
  $sudo -u $loggedInUser $dockutil --add "/Applications/${SELECTION}" --no-restart $UserPlist
done

# $echo "Adding \"Finder\"..."

# $echo "Adding \"Google Chrome\"..."
# $sudo -u $loggedInUser $dockutil --add "/Applications/Google Chrome.app" --no-restart $UserPlist

# $echo "Adding \"Google Slides\"..."
# $sudo -u $loggedInUser $dockutil --add "/Applications/Google Slides.app" --no-restart $UserPlist

# $echo "Adding \"Google Sheets\"..."
# $sudo -u $loggedInUser $dockutil --add "/Applications/Google Sheets.app" --no-restart $UserPlist

# $echo "Adding \"Google Docs\"..."
# $sudo -u $loggedInUser $dockutil --add "/Applications/Google Docs.app" --no-restart $UserPlist

#$echo "Adding \"Acrobat\"..."
#$sudo -u $loggedInUser $dockutil --add "/Applications/Adobe Acrobat DC/Adobe Acrobat.app" --no-restart $UserPlist

# $echo "Adding \"VLC\"..."
# $sudo -u $loggedInUser $dockutil --add "/Applications/VLC.app" --no-restart $UserPlist

# $echo "Adding \"Manager\"..."
# $sudo -u $loggedInUser $dockutil --add "/Applications/Manager.app" --no-restart $UserPlist

# $echo "Adding \"System Preferences\"..."
# $sudo -u $loggedInUser $dockutil --add "System/Applications/System Preferences.app" --no-restart $UserPlist

# $echo "Adding \"Chrome Apps\"..."
# $sudo -u $loggedInUser $dockutil --add "~/Applications/Chrome Apps.localized" --section others --view grid --display folder --no-restart $UserPlist

# $echo "Adding \"Downloads\"..."
# $sudo -u $loggedInUser $dockutil --add "~/Downloads" --section others --view auto --display folder --no-restart $UserPlist

$echo "Restarting Dock..."
$sudo -u $loggedInUser $killall Dock

exit 0