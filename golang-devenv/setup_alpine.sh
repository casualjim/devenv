#!/bin/sh
set -ex

# configure base
apk add --update \
  sudo man curl ca-certificates make shared-mime-info wget less openssh-client zsh gcc musl-dev openssl make \
  tar unzip zip bzip2 gzip p7zip xz \
  git mercurial subversion bzr \
  python-dev ruby-dev nodejs-dev \
  tmux ncurses-terminfo ctags vim

# use /etc/profile.d
mkdir -p /etc/zsh
echo '. /etc/profile' >> /etc/zsh/zprofile

curl -L'#' https://github.com/github/hub/releases/download/v2.2.2/hub-linux-amd64-2.2.2.tgz | sudo tar -C /tmp -xz
mv /tmp/hub-l*/bin/hub /usr/local/bin

npm -g install jshint jslint jsonlint js-yaml
gem install mdl

curl -sL -o /usr/bin/docker https://get.docker.com/builds/Linux/x86_64/docker-latest
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

go get -u github.com/alecthomas/gometalinter
go get -u github.com/golang/lint/golint
go get -u golang.org/x/tools/cmd/...
go get -u github.com/tools/godep
go get -u github.com/jteeuwen/go-bindata/...
go get -u github.com/elazarl/go-bindata-assetfs/...
go get -u github.com/pquerna/ffjson
go get -u github.com/golang/mock/gomock
go get -u github.com/golang/mock/mockgen
go get -u github.com/axw/gocov/gocov
go get -u gopkg.in/matm/v1/gocov-html
go get -u github.com/AlekSi/gocov-xml
go get -u github.com/nsf/gocode
go get -u github.com/jstemmer/gotags
go get -u github.com/smartystreets/goconvey
go get -u github.com/rogpeppe/godef
go get -u github.com/mitchellh/gox
go get -u github.com/constabulary/gb/...
go get -u github.com/derekparker/delve/cmd/...
go get -u github.com/nathany/looper

# install all the linters
gometalinter --install --update

# install direnv
mkdir -p /tmp/direnv
cd /tmp/direnv
git clone https://github.com/direnv/direnv
cd direnv
make install
rm -rf /tmp/direnv
