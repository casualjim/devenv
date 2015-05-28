#!/bin/sh

curl -Ls https://dl.ngrok.com/ngrok_2.0.17_linux_amd64.zip | bsdtar -C /usr/local/bin -xvf- && chmod +x /usr/local/bin/ngrok

vagrant plugin install vagrant-vbguest vagrant-share vagrant-foodshow vagrant-vbox-snapshot

# VMWare
vagrant plugin install vagrant-guests-photon
vagrant plugin install vagrant-vmware-workstation
vagrant plugin license vagrant-vmware-workstation ~/Dropbox/vagrant-workstation.lic

. /etc/os-release
if [ "$ID" = arch ]; then
  # vagrant's copy of curl prevents the proper installation of ruby-libvirt
  sudo mv /opt/vagrant/embedded/lib/libcurl.so{,.backup}
  sudo mv /opt/vagrant/embedded/lib/libcurl.so.4{,.backup}
  sudo mv /opt/vagrant/embedded/lib/libcurl.so.4.3.0{,.backup}
  sudo mv /opt/vagrant/embedded/lib/pkgconfig/libcurl.pc{,.backup}

  CONFIGURE_ARGS="with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib" vagrant plugin install vagrant-libvirt

  # put vagrant's copy of curl back
  sudo mv /opt/vagrant/embedded/lib/libcurl.so{.backup,}
  sudo mv /opt/vagrant/embedded/lib/libcurl.so.4{.backup,}
  sudo mv /opt/vagrant/embedded/lib/libcurl.so.4.3.0{.backup,}
  sudo mv /opt/vagrant/embedded/lib/pkgconfig/libcurl.pc{.backup,}
fi
