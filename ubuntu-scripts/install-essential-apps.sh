#!/bin/bash
cd ~/Downloads

echo Installing NeoFetch...
sudo apt-fast -y install neofetch

echo Installing HTOP...
sudo apt-fast -y install htop

echo Installing Google Chrome...
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-fast install ./google-chrome-stable_current_amd64.deb

echo Installing Bitwarden...
wget https://github.com/bitwarden/clients/releases/download/desktop-v2024.12.1/Bitwarden-2024.12.1-amd64.deb
sudo apt-fast install ./Bitwarden-2024.12.1-amd64.deb

echo Installing Remmina...
sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
sudo apt update
sudo apt-fast install remmina remmina-plugin-rdp remmina-plugin-secret

echo Installing Locate
sudo apt-fast install plocate

echo Installing FSearch...
sudo add-apt-repository ppa:christian-boxdoerfer/fsearch-stable
sudo apt-fast install fsearch

echo Installing ULauncher
sudo add-apt-repository universe -y 
sudo add-apt-repository ppa:agornostal/ulauncher -y 
sudo apt update
sudo apt-fast install ulauncher

echo Installing OneDriver
echo 'deb http://download.opensuse.org/repositories/home:/jstaf/Debian_Unstable/ /' | sudo tee /etc/apt/sources.list.d/home:jstaf.list
curl -fsSL https://download.opensuse.org/repositories/home:jstaf/Debian_Unstable/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_jstaf.gpg > /dev/null
sudo apt update
sudo apt-fast install onedriver