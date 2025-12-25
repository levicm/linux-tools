#!/bin/bash
curl -L https://apt.insync.io/insynchq.gpg 2>/dev/null | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/insynchq.gpg 1>/dev/null
source /etc/os-release
echo "deb http://apt.insync.io/$ID $VERSION_CODENAME non-free contrib" | sudo tee /etc/apt/sources.list.d/insync.list
sudo apt update
sudo apt -y install insync