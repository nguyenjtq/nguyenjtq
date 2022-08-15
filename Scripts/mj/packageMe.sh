#!/bin/bash

echo "Enter package name: "
read packageName
pkgbuild --identifier com.jammies.renewEnrollment --nopayload --scripts ~/Documents/scripts/mj ~/Documents/scripts/mj/$packageName.pkg