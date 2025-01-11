#!/bin/bash
echo Installing ULauncher
sudo add-apt-repository universe -y 
sudo add-apt-repository ppa:agornostal/ulauncher -y 
sudo apt update
sudo apt -y install ulauncher
