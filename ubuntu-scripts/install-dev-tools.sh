#!/bin/bash
echo Installing GIT...
sudo apt-fast -y install git

echo Installing Python3 and pip...
sudo apt-fast -y install python3
sudo apt-fast -y install python3-pip

./develompent/install-vscode.sh

./develompent/install-eclipse.sh

./develompent/install-postman.sh
