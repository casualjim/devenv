#!/bin/sh
set -e -o pipefail -x
# Check which Packer builder type is being used
if [ $PACKER_BUILDER_TYPE = "vmware-iso" ]; then
  # Required for VMware Tools for Linux Guests
  dnf install -yq kernel-headers kernel-devel gcc glibc-headers wget net-tools patch

  # use vmware-tools-patches repo so that vmhgfs works
  git clone https://github.com/rasa/vmware-tools-patches.git
  pushd vmware-tools-patches
  ./download-tools.sh 8.1.0
  ./untar-and-patch.sh
  pushd vmware-tools-distrib
  ./vmware-install.pl -f -d --clobber-kernel-modules=vmblock,vmhgfs,vmsync,vmxnet
  popd
  popd
  rm -rf vmware-tools-patches

  # Disable ThinPrint service
  systemctl stop vmware-tools-thinprint.service
  systemctl disable vmware-tools-thinprint.service

  # Cleanup
  dnf remove -yq gcc glibc-headers wget net-tools

  # Prevent dnf from updating the kernel (and related packages)
  # in order to preserve the VMware kernel extensions
  echo "exclude=kernel*" >> /etc/dnf/dnf.conf
fi
