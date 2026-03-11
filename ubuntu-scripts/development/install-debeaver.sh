#!/bin/bash
echo Installing DBeaver...
wget -O- https://dbeaver.io/debs/dbeaver.gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/dbeaver.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt-get update 
sudo apt-get install dbeaver-ce