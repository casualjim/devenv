#!/bin/sh

mkinitcpio -p linux
passwd -l root
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
