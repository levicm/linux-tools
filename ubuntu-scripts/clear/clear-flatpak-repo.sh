#!/bin/bash
echo Uninstalling unused packages...
flatpak uninstall --unused

echo Fixing any inconsistencies in the repository...
sudo flatpak repair

echo Cleaning up flatpak cache...
sudo rm -rf /var/tmp/flatpak-cache-*
rm -rf ~/.cache/flatpak/*