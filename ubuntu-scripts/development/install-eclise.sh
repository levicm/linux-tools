#!/bin/bash
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