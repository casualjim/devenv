# Packer builds

Contains packer builds for an arch linux base install.

for vmware on arch you need to install vmware-patch after installing vmware

```bash
yaourt -S vmware-patch
sudo systemctl enable vmware
sudo systemctl enable vmware-usbarbitrator
sudo systemctl enable vmware-workstation
```

Qemu:

* [Arch wiki on qemu](https://wiki.archlinux.org/index.php/QEMU)
* [Arch wiki on pci pass through](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF) (pass a video card on)

VMware:

* [Installing as a host](https://wiki.archlinux.org/index.php/VMware%23Configuration#Installation)
* [Installing as a guest](https://wiki.archlinux.org/index.php/VMware/Installing_Arch_as_a_guest)
* And you need to [edit](http://alexmufatti.it/2013/08/20/vmware-crash-on-startup-after-curl-update/) /usr/bin/vmware

The efi template currently only works with qemu.
