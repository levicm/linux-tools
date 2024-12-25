#!/bin/bash
echo Creating folder...
cd ~
mkdir OneDrive

echo Installing RClone...
sudo -v ; curl https://rclone.org/install.sh | sudo bash

echo Configuring RClone...
rclone config

echo Mounting drive...
# To mount OneDrive on startup, open Startup Applications. This depends on the desktop environment you're using so I'll list some of them below and how to access startup applications to add a new entry:
# . Gnome / Unity: search for Startup Applications in the Dash / applications thingy, and in Startup Applications click Add
# . Xfce: launch Session and Startup from the menu, go to the Application Autostart tab and click Add
# . MATE: launch Startup Applications from the menu, and click Add
#
# After clicking Add, use the following:
#
# Name: Rclone OneDrive Mount
# Command: sh -c "rclone --vfs-cache-mode writes mount onedrive: ~/OneDrive"
rclone --vfs-cache-mode writes mount onedrive: ~/OneDrive