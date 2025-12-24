#!/bin/bash
if [[ ! -f /usr/bin/gnome-session ]]
then 
    echo This is not a Gnome system!
    exit 1;
fi

echo This is a gnome system!
echo Installing Gnome Browser Connector...
sudo apt -y install gnome-browser-connector

echo Installing gnome-extensions-cli, a CLI Gnome extensions tool...
sudo apt -y install python3-pip

# On new versions of pip (Ubuntu 23 or higher), this variable is necessary to install gnome-extensions-cli
export PIP_BREAK_SYSTEM_PACKAGES=1
pip3 install --upgrade gnome-extensions-cli

# Adding path only for this session
export PATH=$PATH:~/.local/bin
# Adding path permanently
echo '
PATH=$PATH:~/.local/bin
' >> ~/.bashrc

# CPU Power Manager (not working on Ubuntu 24+)
#echo Installing CPU Power Manager...
#gext install cpupower@mko-sl.de

# Sound Input & Output Device Chooser (not working on Ubuntu 24+)
#echo Installing Sound Input \& Output Device Chooser...
#gext install sound-output-device-chooser@kgshank.net

# Tiling Shell
echo Installing Tiling Shell...
gext install tilingshell@ferrarodomenico.com
# User Themes
echo Installing User Themes...
gext install user-theme@gnome-shell-extensions.gcampax.github.com
# Extension List
echo Installing Extension List...
gext install extension-list@tu.berry
# Auto Power Profile
echo Installing Auto Power Profile...
gext install auto-power-profile@dmy3k.github.io
# Hibernate Status Button
echo Installing Hibernate Status Button...
gext install hibernate-status@dromi
# Caffeine
echo Installing Caffeine...
gext install caffeine@patapon.info