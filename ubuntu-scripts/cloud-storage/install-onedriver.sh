#!/bin/bash
cd ~/Downloads
echo Installing OneDriver
echo 'deb http://download.opensuse.org/repositories/home:/jstaf/Debian_Unstable/ /' | sudo tee /etc/apt/sources.list.d/home:jstaf.list
curl -fsSL https://download.opensuse.org/repositories/home:jstaf/Debian_Unstable/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_jstaf.gpg > /dev/null
sudo apt update
sudo apt-fast install onedriver