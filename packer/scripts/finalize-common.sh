#!/bin/sh

set -x -o pipefail

echo "===> configuring bootloader"
mkinitcpio -p linux

echo "===> stopping root"
passwd --delete root
passwd --lock root

echo "===> removing random-seed for unique images"
rm --force /var/lib/systemd/random-seed

# Note: this image will not boot if /etc/machine-id is not present, but systemd
# will generate a new machine ID if /etc/machine-id is present but empty
echo "===> clear machine id"
truncate --size=0 /etc/machine-id

echo "===> removing SSH host keys"
rm --force /etc/ssh/ssh_host_*
