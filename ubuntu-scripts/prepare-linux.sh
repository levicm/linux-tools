#!/bin/bash
echo Setting date do local time, like Windows does...
timedatectl set-local-rtc 1 --adjust-system-clock
timedatectl

./install-essential-apps.sh

./install-dev-tools.sh

./install-media-apps.sh

./install-gnome-extensions.sh