#!/bin/sh


ln -sf /usr/lib/os-release /etc/arch-release
pacman -S --noconfirm wget unzip net-tools linux-headers abs
pacman -Rcs --noconfirm netctl
sudo -u vagrant -Hi yaourt -S --noconfirm open-vm-tools open-vm-tools-dkms

# abs community/open-vm-tools
# cp /var/abs/community/open-vm-tools/vmware-* /usr/lib/systemd/system

systemctl enable vmtoolsd.service
systemctl enable vmware-vmblock-fuse.service
systemctl enable dkms.service
# systemctl reboot


# mkdir -p /vagrant /mnt/hgfs
# cd /usr/src
# mkdir -p /etc/init.d/rc{0,1,2,3,4,5,6}.d
# git clone https://github.com/rasa/vmware-tools-patches.git
# cd vmware-tools-patches
# ./download-tools.sh 7.1.1
# ./untar-all-and-patch.sh
# ./compile.sh || true

echo 'MODULES="$MODULES vsock vmw_vsock_vmci_transport vmw_balloon vmw_vmci vmwgfx vmhgfs"' >> /etc/mkinitcpio.conf
