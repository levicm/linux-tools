#!/bin/bash
echo Installing gnome-extensions-cli, a CLI Gnome extensions tool...
pip3 install --upgrade gnome-extensions-cli
# CPU Power Manager
echo Installing CPU Power Manager...
gext install cpupower@mko-sl.de
# Sound Input & Output Device Chooser
echo Installing Sound Input \& Output Device Chooser...
gext install sound-output-device-chooser@kgshank.net
# Tiling Shell
echo Installing Tiling Shell...
gext install tilingshell@ferrarodomenico.com
# User Themes
echo Installing User Themes...
gext install user-theme@gnome-shell-extensions.gcampax.github.com
# Extension List
echo Installing Extension List...
gext install extension-list@tu.berry