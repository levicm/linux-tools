#!/bin/bash
echo Installing Node.js v20 and Npm...
# sudo apt -y install nodejs npm
# The apt installation gets just old version 12
# Using fnm we can get more recent versions, as v20...
curl -fsSL https://fnm.vercel.app/install | bash
source /home/levi/.bashrc
fnm install v20.18.1

echo Installing Angular 17...
npm install -g @angular/cli@17

