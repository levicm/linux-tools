#!/bin/bash
echo "🔄 Updating icon cache..." 

sudo gtk-update-icon-cache /usr/share/icons/hicolor 
sudo gtk-update-icon-cache /usr/share/icons/Yaru 
sudo gtk-update-icon-cache /usr/share/icons/Adwaita 

echo "✅ Icon cache updated successfully!"