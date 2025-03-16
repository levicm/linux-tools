#!/bin/bash
echo
echo Installing Epson Printer software...
echo
echo Downloading Epson L355 printer driver...
cd ~/Downloads
wget -c https://download3.ebz.epson.net/dsc/f/03/00/15/64/87/08cd9b6782b8387cb5ddd27486da65fb2548f13a/epson-inkjet-printer-201207w_1.0.1-1_amd64.deb
echo Installing Epson L355 printer driver...
sudo apt -y install ./epson-inkjet-printer-201207w_1.0.1-1_amd64.deb

echo
echo Installing Epson Scanner software...
echo
echo "Installing required libs (libqt and libjpeg)..."
sudo apt -y install qtbase5-dev libjpeg-dev
echo Downloading Epson L355 Scan software...
cd ~/Downloads
wget -c https://download3.ebz.epson.net/dsc/f/03/00/16/14/38/7b1780ace96e2c6033bbb667c7f3ed281e4e9f38/epsonscan2-bundle-6.7.70.0.x86_64.deb.tar.gz
echo Extracting bundle...
tar -xf epsonscan2-bundle-6.7.70.0.x86_64.deb.tar.gz
cd epsonscan2-bundle-6.7.70.0.x86_64.deb/
echo Installing Scan bundle...
./install.sh
echo
echo Software installed!
echo Please, go to printer settings software \(or access CUPS interface on http://localhost:631/\) and install the printer. 