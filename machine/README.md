# Packer builds

Contains packer builds for an arch linux base install.

for vmware on arch you need to install vmware-patch after installing vmware

```bash
yaourt -S vmware-patch
sudo systemctl enable vmware
```

And you need to [edit](http://alexmufatti.it/2013/08/20/vmware-crash-on-startup-after-curl-update/) /usr/bin/vmware

The efi template currently only works with qemu.
