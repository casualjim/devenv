#!/bin/sh

configure_locale(){
  ln --symbolic /usr/share/zoneinfo/UTC /etc/localtime
  localedef --inputfile=en_US --charmap=UTF-8 en_US.UTF-8
}

configure_pacman_keyring() {
  pacman-key --init
  pacman-key --populate archlinux
}

upgrade_system() {
  pacman --sync --noconfirm --refresh --sysupgrade
}

cleanup() {
  rm /etc/securetty
  pacman -Scc --noconfirm
  find /var/cache/pacman/pkg -mindepth 1 -delete
}

configure_locale
configure_pacman_keyring
upgrade_system
cleanup
