#!/bin/bash

# Ask for creds upfront.
sudo -v

# Check if pip3 is installed. If not, this will kick off Xcode install and wait for user to install it.
pip3 -V
# pid=$(pgrep "Install Command Line Developer Tools")
while pid=$(pgrep "Install Command Line Developer Tools") >/dev/null;
do
    pid=$(pgrep "Install Command Line Developer Tools")
    echo "Waiting for Command Line Developer Tools to install."
    sleep 10
done

# Install PyObjC package.
pip3 install -U PyObjC
echo "Installed PyObjC Python package."