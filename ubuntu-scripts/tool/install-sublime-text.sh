#!/bin/bash
echo Installing Sublime Text...
wget -cqO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt -y install sublime-text
# Create a symbolic link to the executable to be able to run it from the terminal
sudo sudo update-alternatives --install /usr/bin/sublime sublime /opt/sublime_text/sublime_text 2024