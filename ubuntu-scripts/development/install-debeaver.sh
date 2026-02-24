#!/bin/bash
echo Installing DBeaver...
sudo wget -O /usr/share/keyrings/dbeaver.gpg https://dbeaver.io/debs/dbeaver.gpg.key
echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt-get update 
sudo apt-get install dbeaver-ce