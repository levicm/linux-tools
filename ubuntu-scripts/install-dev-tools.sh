#!/bin/bash
echo Installing GIT...
sudo apt -y install git

echo Installing Python3 and pip...
sudo apt -y install python3
sudo apt -y install python3-pip

./develompent/install-vscode.sh

./develompent/install-eclipse.sh

./develompent/install-postman.sh
