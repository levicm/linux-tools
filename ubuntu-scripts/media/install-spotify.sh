#!/bin/bash
echo Installing Spotify...
curl -fsSL https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.gpg | sudo gpg --dearmor -o /usr/share/keyrings/spotify.gpg
echo "deb [signed-by=/usr/share/keyrings/spotify.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt -y install spotify-client