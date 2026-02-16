#!/bin/bash
echo Installing Google Chrome...
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-linux-signing-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux-signing-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update 
sudo apt install google-chrome-stable
# Installing directly from the .deb file since the repository method can sometimes cause issues with dependencies.
#cd ~/Downloads
#wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#sudo apt -y install ./google-chrome-stable_current_amd64.deb
