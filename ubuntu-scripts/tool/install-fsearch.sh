#!/bin/bash
echo Installing FSearch...
sudo add-apt-repository ppa:christian-boxdoerfer/fsearch-stable
sudo apt update
sudo apt -y install fsearch