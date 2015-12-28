#!/bin/sh

# Document box build time
echo 'Built by Packer at' $(date '+%H:%M %Z on %B %-d, %Y') \
    > /root/vagrant-box-build-time
chmod 0644 /root/vagrant-box-build-time
chcon system_u:object_r:admin_home_t:s0 /root/vagrant-box-build-time

# Delete and lock root password
passwd --delete root
passwd --lock root

# Remove UUID from non-loopback interface configuration files
sed --in-place '/^UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth*

# Remove random-seed, so it’s not the same in every image
rm --force /var/lib/systemd/random-seed

# Truncate machine-id, for the same reasons random-seed is removed
# Note: this image will not boot if /etc/machine-id is not present, but systemd
# will generate a new machine ID if /etc/machine-id is present but empty
truncate --size=0 /etc/machine-id

# Remove SSH host keys
rm --force /etc/ssh/ssh_host_*

# Clean up dnf repo data, keys & logs
dnf clean all
rpm -e gpg-pubkey
rm --recursive --force /var/lib/dnf/history/*
rm --recursive --force /var/lib/dnf/yumdb/*
truncate --no-create --size=0 /var/log/dnf.*

# Force the filesystem to reclaim space from deleted files
dd if=/dev/zero of=/var/tmp/zeros bs=1M
rm --force /var/tmp/zeros
