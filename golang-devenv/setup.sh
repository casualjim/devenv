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

chmod +x /usr/bin/go-wrapper /usr/bin/docker /tmp/gonative
/tmp/gonative build --target /usr/src/go
export PATH=/usr/src/go/bin:$PATH

export GOPATH=/usr/local/go
mkdir -p $GOPATH/src
export PATH=/usr/local/go/bin:$PATH

echo '
export GOPATH=/usr/local/go
export GOROOT=/usr/src/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
' > /etc/profile.d/golang.sh

go get -u github.com/golang/lint/golint
go get -u golang.org/x/tools/cmd/...
go get -u github.com/tools/godep
go get -u github.com/jteeuwen/go-bindata/...
go get -u github.com/elazarl/go-bindata-assetfs/...
go get -u github.com/redefiance/go-find-references
go get -u github.com/sqs/goreturns
go get -u github.com/pquerna/ffjson
go get -u github.com/clipperhouse/gen
go get -u code.google.com/p/gomock/gomock
go get -u code.google.com/p/gomock/mockgen
go get -u github.com/axw/gocov/gocov
go get -u gopkg.in/matm/v1/gocov-html
go get -u github.com/AlekSi/gocov-xml
go get -u github.com/nsf/gocode
go get -u github.com/kisielk/errcheck
go get -u github.com/jstemmer/gotags
go get -u github.com/smartystreets/goconvey
go get -u github.com/rogpeppe/godef
go get -u github.com/github/hub
go get -u github.com/mitchellh/gox
go get -u github.com/constabulary/gb/...
go get -u github.com/derekparker/delve/cmd/dlv
