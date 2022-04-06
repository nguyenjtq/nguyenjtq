#!/bin/bash

# Ask for creds upfront.
sudo -v

# Creates 'match' variable to check for python version installed, if any.
# Then greps it down to a known regex pattern.
# An additional grep happens to pull only the python version.
match=$(ls -l /usr/local/bin/python* | grep -o '\/usr\/local\/bin\/python\d.\d*-config' | grep -o '\d.\d*')

# Conditional statement to check if $match is empty.
# If empty, python is not installed and should be. Then create symlink and install pyobjc.
# If NOT empty, python is installed. Create symlink and install pyobjc.
if test -z "$match";
then
    echo "Python not installed. Downloading Python3.10."
    curl -o ~/Downloads/python3.10.4.pkg 'https://www.python.org/ftp/python/3.10.4/python-3.10.4-macos11.pkg'
    sudo installer -pkg ~/Downloads/python3.10.4.pkg -target /

    match=$(ls -l /usr/local/bin/python* | grep -o '\/usr\/local\/bin\/python\d.\d*-config' | grep -o '\d.\d*')
    sudo ln -s -f /usr/local/bin/python$match /usr/local/bin/python
    echo "Symlink created at for python$match at /usr/local/bin/python."
else
    echo $match
    sudo ln -s -f /usr/local/bin/python$match /usr/local/bin/python
    echo "Symlink created at for python$match at /usr/local/bin/python."
    python --version
fi