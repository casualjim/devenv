#!/bin/sh

set -e

if [[ "$USER" != "root" ]]; then
  echo "This script needs to be run as root"
  exit 1
fi

if [ -z "$1" ]; then
  echo "You need to provide the package lists for this install to work"
  exit 1
fi

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

ROOTFS="/var/lib/machines/$1"

# Print pretty colors to stdout in Blue.
function ppinfo() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;34m%s\033[0m' "$@"
  else
    printf '\033[0;34m%s\033[0m\n' "$@"
  fi
}

# Print pretty colors to stdout in Green.
function ppsuccess() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;32m%s\033[0m' "$@"
  else
    printf '\033[0;32m%s\033[0m\n' "$@"
  fi
}

# Print pretty colors to stdout in Purple.
function ppemphasis() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;35m%s\033[0m' "$@"
  else
    printf '\033[0;35m%s\033[0m\n' "$@"
  fi
}

# Print pretty colors to stdout in Brown.
function ppwarning() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;33m%s\033[0m' "$@"
  else
    printf '\033[0;33m%s\033[0m\n' "$@"
  fi
}

# Print pretty colors to stdout in Red.
function ppdanger() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;31m%s\033[0m' "$@"
  else
    printf '\033[0;31m%s\033[0m\n' "$@"
  fi
}


function cleanup {
    ppinfo "=> Removing install files from ${ROOTFS}"
    echo ""
    if [[ -e "${ROOTFS}/var/lib/archie" ]]; then
      ppemphasis "removing $ROOTFS/var/lib/archie"
      rm -rf "${ROOTFS}/var/lib/archie"
    fi
    if [[ -e "${ROOTFS}/install.sh" ]]; then
      ppemphasis "removing $ROOTFS/install.sh"
      rm -rf "${ROOTFS}/install.sh"
    fi
}
trap cleanup EXIT

ppinfo "=> Preparing Archie SystemD container Root FS"
echo ""

systemd-nspawn -M $1 --directory /var/lib/machines/$1 --template /var/lib/machines/archie-mini echo "$ROOTFS created"
mkdir -p ${ROOTFS}/var/lib/archie/repo/
install -D --mode=0644 --owner=root --group=root ${DIR}/archie-*.pklst ${ROOTFS}/var/lib/archie/repo/
install --mode=0755 --owner=root --group=root "${DIR}/install-packages.sh" "${ROOTFS}/install.sh"

systemd-nspawn -M $1 /install.sh "$@"
cp -a ${DIR}/overlay/zsh-config/* "${ROOTFS}"
