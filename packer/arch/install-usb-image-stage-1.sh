#!/bin/bash

set -e
FQDN='archie-install'
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

echo '
ACTION=="add", SUBSYSTEM=="net", ENV{INTERFACE}=="en*|eth*", ENV{SYSTEMD_WANTS}="dhcpcd@$name.service"
' > /etc/udev/rules.d/81-dhcpd.rules

mkdir -p /etc/systemd/system/getty@tty1.service.d
echo '
ExecStart=-/sbin/agetty --autologin root --noclear %I 38400 linux
' > /etc/systemd/system/getty@tty1.service.d/autologin.conf

echo "==> configuring network"
echo '[Match]
Name=eth* en*
[Network]
DHCP=yes
' > /etc/systemd/network/80-dhcp.network
systemctl enable systemd-networkd.service

echo '
# See resolved.conf(5) for details
[Resolve]
#DNS=
FallbackDNS=8.8.8.8 8.8.4.4 2001:4860:4860::8888 2001:4860:4860::8844
#LLMNR=yes
'
systemctl enable systemd-resolved.service

echo "===> setting root password"
usermod -p ${PASSWORD} root

# install ssh server
echo "===> configuring ssh server"
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
systemctl enable sshd.service

echo "===> configuring cpio"
echo '
# vim:set ft=sh
MODULES=""
BINARIES=""
FILES=""
COMPRESSION="gzip"
HOOKS="base udev autodetect modconf block filesystems keyboard fsck"
' > /etc/mkinitcpio.conf
mkinitcpio -p linux


echo "===> configuring bootloader"
sed -i "s/GRUB_DEFAULT=.*/GRUB_DEFAULT=0/g" /etc/default/grub
sed -i "s/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/g" /etc/default/grub
grub-install --target=i386-pc --recheck ${DISK}
grub-mkconfig -o /boot/grub/grub.cfg
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Archie\ Install --recheck
grub-mkconfig -o /boot/grub/grub.cfg
mkdir -p /boot/efi/EFI/boot
cp /boot/efi/EFI/Archie\ Install/grubx64.efi  /boot/efi/EFI/boot/bootx64.efi

echo "===> cleaning up"
pacman -Scc --noconfirm
