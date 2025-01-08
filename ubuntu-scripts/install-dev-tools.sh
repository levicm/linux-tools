#!/bin/bash
cd ~/Downloads

echo Installing Node.js v20 and Npm...
# sudo apt-fast -y install nodejs npm
# The apt installation gets just old version 12
# Using fnm we can get more recent versions, as v20...
curl -fsSL https://fnm.vercel.app/install | bash
source /home/levi/.bashrc
fnm install v20.18.1

echo Installing Angular 17...
npm install -g @angular/cli@17

echo Installing VSCode...
cd ~/Downloads
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo apt update
sudo apt-fast install code

echo Installing Eclipse IDE...
cd ~/Downloads
wget https://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/2024-12/R/eclipse-jee-2024-12-R-linux-gtk-x86_64.tar.gz
cd /opt
sudo tar -xvzf ~/Downloads/eclipse-jee-*
cd ~/Downloads
cat > eclipse.desktop <<EOF
[Desktop Entry]
Name=Eclipse
Type=Application
Exec=/opt/eclipse/eclipse
Terminal=false
Icon=/opt/eclipse/icon.xpm
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
Name[en]=Eclipse
Name[en_US]=Eclipse
EOF
sudo desktop-file-install eclipse.desktop

echo Installing Postman...
cd ~/Downloads
wget wget --output-document=postman.tar.gz https://dl.pstmn.io/download/latest/linux_64
tar -xf postman.tar.gz
sudo mv ./Postman /opt
cat > postman.desktop <<EOF
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=/opt/Postman/app/Postman %U
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOF
sudo desktop-file-install postman.desktop
