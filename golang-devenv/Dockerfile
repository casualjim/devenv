FROM alpine:3.2
MAINTAINER Ivan Porto Carrero

ENV GOLANG_VERSION 1.5.1
ENV GOLANG_SRC_URL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz
ENV GOLANG_SRC_SHA1 0df564746d105f4180c2b576a1553ebca9d9a124

ENV GOLANG_BOOTSTRAP_VERSION 1.4.3
ENV GOLANG_BOOTSTRAP_URL https://golang.org/dl/go$GOLANG_BOOTSTRAP_VERSION.src.tar.gz
ENV GOLANG_BOOTSTRAP_SHA1 486db10dc571a55c8d795365070f66d343458c48

ADD https://get.docker.com/builds/Linux/x86_64/docker-latest /usr/bin/docker

ADD gemrc.root /root/.gemrc
ADD simpleinit /usr/bin/

RUN set -ex \
  && apk update \
  && apk add \
      sudo man curl ca-certificates make shared-mime-info wget less openssh-client zsh bash gcc musl-dev readline-dev openssl \
      tar unzip zip bzip2 gzip p7zip xz \
      git mercurial subversion bzr \
      python-dev ruby-dev nodejs-dev \
      tmux ncurses-terminfo ctags vim \
  && mkdir -p /etc/zsh \
  && echo '. /etc/profile' >> /etc/zsh/zprofile \
  && curl -L'#' https://github.com/github/hub/releases/download/v2.2.2/hub-linux-amd64-2.2.2.tgz | sudo tar -C /tmp -xz \
  && mv /tmp/hub-l*/bin/hub /usr/local/bin \
  && npm -g install jshint jslint jsonlint js-yaml \
  && gem install mdl \
  && chmod +x /usr/bin/docker \
  \
  && mkdir -p /usr/local/bootstrap \
  && wget -q "$GOLANG_BOOTSTRAP_URL" -O golang.tar.gz \
  && echo "$GOLANG_BOOTSTRAP_SHA1  golang.tar.gz" | sha1sum -c - \
  && tar -C /usr/local/bootstrap -xzf golang.tar.gz \
  && rm golang.tar.gz \
  && cd /usr/local/bootstrap/go/src \
  && ./make.bash \
  && export GOROOT_BOOTSTRAP=/usr/local/bootstrap/go \
  \
  && wget -q "$GOLANG_SRC_URL" -O golang.tar.gz \
  && echo "$GOLANG_SRC_SHA1  golang.tar.gz" | sha1sum -c - \
  && tar -C /usr/local -xzf golang.tar.gz \
  && rm golang.tar.gz \
  && cd /usr/local/go/src \
  && ./make.bash \
  \
  && rm -rf /usr/local/bootstrap \
  \
  && export GOPATH=/go \
  && export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH \
  && mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH" \
  && go get -u github.com/alecthomas/gometalinter \
  && go get -u github.com/golang/lint/golint \
  && go get -u golang.org/x/tools/cmd/... \
  && go get -u github.com/tools/godep \
  && go get -u github.com/jteeuwen/go-bindata/... \
  && go get -u github.com/elazarl/go-bindata-assetfs/... \
  && go get -u github.com/pquerna/ffjson \
  && go get -u github.com/golang/mock/gomock \
  && go get -u github.com/golang/mock/mockgen \
  && go get -u github.com/axw/gocov/gocov \
  && go get -u gopkg.in/matm/v1/gocov-html \
  && go get -u github.com/AlekSi/gocov-xml \
  && go get -u github.com/nsf/gocode \
  && go get -u github.com/jstemmer/gotags \
  && go get -u github.com/smartystreets/goconvey \
  && go get -u github.com/rogpeppe/godef \
  && go get -u github.com/mitchellh/gox \
  && go get -u github.com/constabulary/gb/... \
  && go get -u github.com/derekparker/delve/cmd/... \
  && go get -u github.com/nathany/looper \
  && gometalinter --install --update \
  && mkdir -p /tmp/direnv \
  && cd /tmp/direnv \
  && git clone https://github.com/direnv/direnv \
  && cd direnv \
  && make install \
  && rm -rf /tmp/direnv \
  && apk del bash gcc

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

CMD ["/usr/bin/simpleinit"]
