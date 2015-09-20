#!/bin/bash
set -e
set -x

# configure base
apt-get update -qq
apt-get install --no-install-recommends -qq -y \
  sudo man curl locales ca-certificates mime-support wget less openssh-client zsh

# configure locale
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
locale-gen
rm /etc/locale.gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

# use /etc/profile.d
echo '. /etc/profile' >> /etc/zsh/zprofile

# install dev utils like compilers and package tools
apt-get install -qq -y --no-install-recommends \
  tar unzip zip bzip2 pbzip2 gzip p7zip xz-utils \
  git mercurial subversion bzr \
  gcc libc6-dev make clang libclang-dev cmake python-dev npm ruby nodejs \
  tmux ncurses-term exuberant-ctags vim-nox httpie direnv

ln -sf /usr/bin/nodejs /usr/bin/node
curl -L'#' https://github.com/github/hub/releases/download/v2.2.1/hub-linux-amd64-2.2.1.tar.gz | sudo tar -C /tmp -xz
mv /tmp/hub-l*/hub /usr/local/bin

echo '
---
:verbose: false
:update_sources: true
:sources:
  - http://gems.rubyforge.org/
  - http://rubygems.org/
gem: --no-ri --no-rdoc
' > /root/.gemrc

npm -g install jshint jslint jsonlint js-yaml
gem install mdl

chmod +x /usr/bin/docker
curl -sL https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz | tar -C /usr/local -xz
export PATH=/usr/local/go/bin:$PATH

export GOPATH=/usr/local/share/go
mkdir -p $GOPATH/src
export PATH=/usr/local/share/go/bin:$PATH

echo '
export GOPATH=/usr/local/share/go
export GOROOT=/usr/local/go
export PATH=$GOPATH/bin:$PATH:$GOROOT/bin
' > /etc/profile.d/golang.sh

go get -u github.com/golang/lint/golint
go get -u golang.org/x/tools/cmd/...
go get -u github.com/tools/godep
go get -u github.com/jteeuwen/go-bindata/...
go get -u github.com/elazarl/go-bindata-assetfs/...
go get -u github.com/sqs/goreturns
go get -u github.com/pquerna/ffjson
go get -u github.com/clipperhouse/gen
go get -u github.com/golang/mock/gomock
go get -u github.com/golang/mock/mockgen
go get -u github.com/axw/gocov/gocov
go get -u gopkg.in/matm/v1/gocov-html
go get -u github.com/AlekSi/gocov-xml
go get -u github.com/nsf/gocode
go get -u github.com/kisielk/errcheck
go get -u github.com/jstemmer/gotags
go get -u github.com/smartystreets/goconvey
go get -u github.com/rogpeppe/godef
go get -u github.com/mitchellh/gox
go get -u github.com/constabulary/gb/...
go get -u github.com/derekparker/delve/cmd/dlv
