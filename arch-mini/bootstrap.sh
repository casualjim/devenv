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
set -e
arrow="\033[1;34m=>\033[m"

ROOTFS="$DIR/rootfs"

echo -e "${arrow} Preparing Minimal Arch Container Root FS"
echo ""

umask 022
btrfs subvolume create "${ROOTFS}"

function cleanup {
    echo -e "${arrow} Removing ${ROOTFS}"
    btrfs subvolume delete -c "${ROOTFS}"
}
trap cleanup EXIT

hash pacstrap &>/dev/null || pacman -S arch-install-scripts

pacstrap -c -G -M -d "$ROOTFS" $(cat $DIR/archie-core.pklst)
cp "${DIR}/files/locale.conf" "${ROOTFS}/etc/locale.conf"
cp "${DIR}/files/pacman.conf" "${ROOTFS}/etc/pacman.conf"
cp "${DIR}/files/mirrorlist" "${ROOTFS}/etc/pacman.d/mirrorlist"

DISTDIR=`mktemp -d`
cd "$DISTDIR"
DATE="$(date --iso-8601)"
fname="arch-mini-bootstrap_${DATE}"
echo ""
echo -e "${arrow} Creating Arch Mini Bootstrap tarball: ${DISTDIR}/${fname}.tar.xz"
echo ""
tar --create --xz --numeric-owner --xattrs --acls --directory="${ROOTFS}" --file="${fname}.tar.xz" .
sha512sum "${fname}.tar.xz" | tee "${fname}.sha512" &> /dev/null
chown ivan:ivan "${fname}.tar.xz" "${fname}.sha512"
mv "${fname}.tar.xz" "${fname}.sha512" /home/ivan/Dropbox/Linux/arch-mini/
