#!/bin/bash
cd ~/Downloads

echo Installing NeoFetch...
sudo apt-fast -y install neofetch

echo Installing NeoFetch...
sudo apt-fast -y install htop

echo  Installing Google Chrome...
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

echo Installing Bitwarden...
wget https://github.com/bitwarden/clients/releases/download/desktop-v2024.12.1/Bitwarden-2024.12.1-amd64.deb
sudo apt install ./Bitwarden-2024.12.1-amd64.deb