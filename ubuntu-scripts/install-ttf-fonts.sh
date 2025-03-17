#!/bin/bash
HOME_FONT="$HOME/.fonts"
MOST_DISTROS="/usr/share/fonts"
RHL5="/usr/X11R6/lib/X11/fonts"
RHL6="/usr/X11R6/lib/X11/fonts"

if test -e $MOST_DISTROS ; then
    FONT_PATH=$MOST_DISTROS
elif test -e $RHL5 ; then
    FONT_PATH=$RHL5
elif test -e $RHL6 ; then
    FONT_PATH=$RHL6
else
    FONT_PATH=$HOME_FONT
fi

FONT_PATH=$FONT_PATH"/wps-fonts"

# flush stdin
while read -r -t 0; do read -r; done 
echo -e "\nFonts will be installed in: "$FONT_PATH
read -p "Continue with installation? [Y/n] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
  if [ ! -d "$FONT_PATH" ]; then
    echo -e "\nCreating Font Directory..."
    sudo mkdir $FONT_PATH
  fi

  echo -e "\nInstalling Fonts..."
  wget https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/assets/wps-fonts.zip
  sudo unzip wps-fonts.zip -d $FONT_PATH
  echo -e "\nFixing Permissions..."
  sudo chmod 644 $FONT_PATH/*
  echo -e "\nRebuilding Font Cache..."
  sudo fc-cache -vfs
  echo -e "\nCleaning downloaded files..."
  rm wps-fonts.zip
  echo -e "\nInstallation Finished!"
fi
