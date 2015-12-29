#!/bin/sh
set -x -o pipefail

# VirtualBox Guest Additions
pacman -S --noconfirm linux-headers virtualbox-guest-modules virtualbox-guest-utils mesa-libgl
systemctl enable vboxservice.service
usermod -a -G vboxsf vagrant
