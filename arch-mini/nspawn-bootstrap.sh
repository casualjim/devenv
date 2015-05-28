#!/bin/sh

set -e

if [[ "$USER" != "root" ]]; then
  echo "This script needs to be run as root"
  exit 1
fi

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
arrow="\033[1;34m=>\033[m"

ROOTFS="/var/lib/machines/archie-mini"

echo -e "${arrow} Preparing Minimal Arch Container Root FS"
echo ""

umask 022
btrfs subvolume create "${ROOTFS}"

function cleanup {
    echo ""
    echo -e "${arrow} Removing install files from ${ROOTFS}"
    [ -e "${ROOTFS}/install.sh" ] && rm -rf "${ROOTFS}/install.sh"
}
trap cleanup EXIT

hash pacstrap &>/dev/null || pacman -S arch-install-scripts

pacstrap -c -G -M -d "$ROOTFS" pacman
cp "${DIR}/files/locale.conf" "${ROOTFS}/etc/locale.conf"
cp "${DIR}/files/pacman.conf" "${ROOTFS}/etc/pacman.conf"
cp "${DIR}/files/mirrorlist" "${ROOTFS}/etc/pacman.d/mirrorlist"

echo ""
echo -e "${arrow} Configuring Minimal Arch Container Root FS"
echo ""
install --mode=0755 --owner=root --group=root "${DIR}/install-minimal.sh" "${ROOTFS}/install.sh"
systemd-nspawn -M archie-mini /install.sh
