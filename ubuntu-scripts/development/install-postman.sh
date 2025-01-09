#!/bin/bash
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
