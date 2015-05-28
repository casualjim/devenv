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


install_remote_binary() {
  ppinfo "installing $1 from $2"
  curl -o "/usr/bin/$1" -L'#' "$2"
  chmod +x "/usr/bin/$1"
  ppsuccess "installed $1"
}


install_archie_core() {
  ppemphasis "==> installing archie-core"
  install_remote_binary jq http://stedolan.github.io/jq/download/linux64/jq
  install_remote_binary gosu "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64"
  install_remote_binary direnv "https://github.com/zimbatm/direnv/releases/download/v2.6.0/direnv.linux-amd64"
}

install_golang() {
  ppemphasis "==> installing golang env"
  gonative build --target /usr/src/go
  export PATH=/usr/src/go/bin:$PATH

  echo '
export GOPATH=/usr/local/go
export GOROOT=/usr/src/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
' > /etc/profile.d/golang.sh

  . /etc/profile.d/golang.sh

  ppinfo "===> installing go dev tools"
  go get -u github.com/golang/lint/golint
  ppsuccess "====> installed golint"
  go get -u golang.org/x/tools/cmd/...
  ppsuccess "====> installed golang tools from golang.org/x/tools"
  go get -u github.com/tools/godep
  ppsuccess "====> installed godep"
  go get -u github.com/jteeuwen/go-bindata/...
  go get -u github.com/elazarl/go-bindata-assetfs/...
  ppsuccess "====> installed bindata"
  go get -u github.com/redefiance/go-find-references
  ppsuccess "====> installed find-references"
  go get -u github.com/sqs/goreturns
  ppsuccess "====> installed goreturns"
  go get -u github.com/pquerna/ffjson
  ppsuccess "====> installed ffjson"
  go get -u github.com/clipperhouse/gen
  ppsuccess "====> installed clipperhouse gen"
  go get -u code.google.com/p/gomock/gomock
  go get -u code.google.com/p/gomock/mockgen
  ppsuccess "====> installed gomock"
  go get -u github.com/axw/gocov/gocov
  go get -u gopkg.in/matm/v1/gocov-html
  go get -u github.com/AlekSi/gocov-xml
  ppsuccess "====> installed gocode"
  go get -u github.com/nsf/gocode
  go get -u github.com/kisielk/errcheck
  ppsuccess "====> installed errcheck"
  go get -u github.com/jstemmer/gotags
  ppsuccess "====> installed gotags"
  go get -u github.com/smartystreets/goconvey
  ppsuccess "====> installed goconvey"
  go get -u github.com/rogpeppe/godef
  ppsuccess "====> installed godef"
  go get -u github.com/gogo/protobuf/proto
  go get -u github.com/gogo/protobuf/protoc-gen-gogo
  go get -u github.com/gogo/protobuf/gogoproto
  ppsuccess "====> installed gogoproto"
  go get -u github.com/github/hub
  ppsuccess "====> installed hub"
  go get -u github.com/mitchellh/gox
  ppsuccess "====> installed gox"
  go get -u github.com/derekparker/delve/cmd/dlv
  ppsuccess "====> installed dlv"
}

install_archie_devenv() {
  ppemphasis "==> installing archie-devenv"
  git clone git://github.com/tarjoilija/zgen.git /usr/share/zsh/scripts/zgen
  echo '---
:verbose: false
:update_sources: true
:sources:
  - http://gems.rubyforge.org/
  - http://rubygems.org/
gem: --no-ri --no-rdoc
' > /root/.gemrc
  ppsuccess "===> configured gemrc for root"

  npm -g install jshint jslint jsonlint js-yaml
  gem install mdl

  install_remote_binary "gonative" "https://www.dropbox.com/s/jl8w66mvwakpspa/gonative?dl=1"
  install_golang
}

install_pkg_list() {
  pth="/var/lib/archie/repo/${1}.pklst"

  if [[ ! -e "$pth" ]]; then
    ls /var/lib/archie/repo
    ppdanger "Couldn't find ${1} in /var/lib/archie/repo"
    exit 1
  fi


  if [[ "$1" = "archie-devenv" ]]; then
    pacman -Qi vim-minimal > /dev/null && pacman -Rcs --noconfirm vim-minimal || true
  fi

  ppinfo "==> installing pacman packages"
  pacman -Syy --noconfirm
  pacman -S --noconfirm --needed $(cat "$pth")
  pacman -Scc --noconfirm

  if [[ "$1" = "archie-core" ]]; then
    install_archie_core
  fi

  if [[ "$1" = "archie-devenv" ]]; then
    install_archie_devenv
  fi
}

for pkg in "$@"; do
  install_pkg_list "$pkg"
done

chsh -s /bin/zsh
zsh -l -c 'echo "zsh configured for $USER"'
if [[ -e "${PERSONAL}" ]]; then
  curr_dir=$HOME/dot-files
  git clone --recursive https://github.com/casualjim/dot-files $curr_dir

  cd $curr_dir
  ln -sf ${curr_dir}/vimreboot $HOME/.vim
  ln -sf ${curr_dir}/vimreboot/vimrc $HOME/.vimrc
  ln -sf ${curr_dir}/ctags $HOME/.ctags
  ln -sf ${curr_dir}/zshrc $HOME/.zshrc
  ln -sf ${curr_dir}/.tmux.conf $HOME/.tmux.conf
  ln -sf ${curr_dir}/gitconfig $HOME/.gitconfig

  script -qc "vim -e +qall" /dev/null > /dev/null
  cd $HOME/.vim/bundle/YouCompleteMe
  ./install.sh --clang-completer --gocode-completer
  . $HOME/.zshrc
fi
