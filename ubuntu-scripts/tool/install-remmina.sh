#!/bin/bash
echo Installing Remmina...
sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
sudo apt update
sudo apt -y install remmina remmina-plugin-rdp remmina-plugin-secret
