#!/bin/bash
echo Installing Google Chrome...
cd ~/Downloads
wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt -y install ./google-chrome-stable_current_amd64.deb
