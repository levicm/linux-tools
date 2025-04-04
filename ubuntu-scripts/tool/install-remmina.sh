#!/bin/bash
echo Installing Remmina...
sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
sudo apt update
sudo apt -y install remmina remmina-plugin-rdp remmina-plugin-secret
# Remove the repository from the sources list because it is problematic
sudo rm /etc/apt/sources.list.d/remmina-ppa-team-ubuntu-remmina-next-oracular.sources