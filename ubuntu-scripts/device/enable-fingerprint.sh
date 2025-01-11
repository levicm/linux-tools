#!/bin/bash
echo Installing fingerprint libs...
sudo apt -y install fprintd libpam-fprintd
echo Enabling fingerprint authentication...
sudo pam-auth-update --enable fprintd
#echo Adding fingerprint...
read -r -p "Do you want to configure a new fingerprint? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    fprintd-enroll --finger right-index-finger
fi
