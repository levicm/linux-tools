#!/bin/bash
echo Installing DBeaver...
# Using debian package...
#cd ~/Downloads
#wget -c https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
#sudo dpkg -i dbeaver-ce_latest_amd64.deb
#cd ~/

# Using repository...
sudo wget -O /usr/share/keyrings/dbeaver.gpg.key https://dbeaver.io/debs/dbeaver.gpg.key
echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg.key] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt-get update 
sudo apt-get install dbeaver-ce