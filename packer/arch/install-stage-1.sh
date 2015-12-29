#!/bin/bash

pacman -Syyu

FQDN='vbox-arch'
KEYMAP='us'
LANGUAGE='en_US.UTF-8'
PASSWORD=$(/usr/bin/openssl passwd -crypt 'vagrant')
TIMEZONE='UTC'

# configure hostname
echo "===> configuring hostname"
echo "${FQDN}" > /etc/hostname
/usr/bin/ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc --utc

# configure locales
echo "===> configuring locales"
echo 'KEYMAP=${KEYMAP}' > /etc/vconsole.conf
sed -i 's/#${LANGUAGE}/${LANGUAGE}/' /etc/locale.gen
locale-gen

echo "==> configuring network"
mkdir -p /etc/systemd/network
echo '[Match]
Name=eth* en*
[Network]
DHCP=yes
' > /etc/systemd/network/80-dhcp.network
systemctl enable systemd-networkd.service

echo '
# See resolved.conf(5) for details
[Resolve]
DNS=8.8.8.8 8.8.4.4
FallbackDNS=2001:4860:4860::8888 2001:4860:4860::8844
#LLMNR=yes
' > /etc/systemd/resolved.conf
systemctl enable systemd-resolved.service

# install ssh server
echo "===> configuring ssh server"
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl enable sshd.service

echo "===> setting root password"
usermod -p ${PASSWORD} root

echo "===> disabling fsck for btrfs volumes"
systemctl mask systemd-fsck-root.service

# Tell udev to disable the assignment of fixed network interface names
# http://freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
# in the cloud or on vagrant eth0 is very much the default ethernet adapter
# we don't want it to be tied to the hardware
echo "===> disabling assignment of fixed hardware based network names"
ln --symbolic /dev/null /etc/udev/rules.d/80-net-setup-link.rules

echo "===> configuring cpio"
echo '
# vim:set ft=sh
MODULES="btrfs"
BINARIES=""
FILES=""
COMPRESSION="gzip"
HOOKS="base udev autodetect modconf block filesystems keyboard btrfs"
' > /etc/mkinitcpio.conf
mkinitcpio -p linux

echo "===> cleaning up"
pacman -Scc --noconfirm
