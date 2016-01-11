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

source ./_logging.sh
arrow="\033[1;34m=>\033[m"

ROOTFS="/var/lib/machines/archie-mini"

ppinfo -e "${arrow} Preparing Minimal Arch Container Root FS"
echo ""

umask 022
btrfs subvolume create "${ROOTFS}"
ppsuccess "  -> subvolume created"
function cleanup {
    local r=$?
    trap - EXIT INT QUIT TERM HUP

    echo ""
    ppinfo -e "${arrow} Removing install files from ${ROOTFS}"
    [ -e "${ROOTFS}/install.sh" ] && rm -rf "${ROOTFS}/install.sh"
    [ -e "${ROOTFS}/_logging.sh" ] && rm -rf "${ROOTFS}/_logging.sh"
}

abort() {
	pperror "${arrow} Aborting..."
	cleanup 255
}

trap_abort() {
	trap - EXIT INT QUIT TERM HUP
	abort
}
trap cleanup EXIT
trap 'trap_abort' INT QUIT TERM HUP

hash pacstrap &>/dev/null || pacman -S arch-install-scripts

pacstrap -c -G -M -d "$ROOTFS" pacman
cp "${DIR}/files/locale.conf" "${ROOTFS}/etc/locale.conf"
cp "${DIR}/files/pacman.conf" "${ROOTFS}/etc/pacman.conf"
cp "${DIR}/files/mirrorlist" "${ROOTFS}/etc/pacman.d/mirrorlist"

echo ""
echo -e "${arrow} Configuring Minimal Arch Container Root FS"
echo ""
install --mode=0755 --owner=root --group=root "${DIR}/_logging.sh" "${ROOTFS}/_logging.sh"
install --mode=0755 --owner=root --group=root "${DIR}/install-minimal.sh" "${ROOTFS}/install.sh"
systemd-nspawn -M archie-mini /install.sh
