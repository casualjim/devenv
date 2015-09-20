FROM casualjim/godev:1.5
MAINTAINER Ivan Porto Carrero

ADD setup.sh /tmp/

RUN \
  useradd -m -U -s /bin/zsh ivan && \
  touch /home/ivan/.zshrc && \
  echo 'ivan ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ivan && \
  sudo -Hi -u ivan zsh -c /tmp/setup.sh && \
  apt-get clean -q && \
  rm -rf  /tmp/* /var/tmp/* /var/lib/apt/lists/*


WORKDIR /home/ivan
ENV GOPATH /home/ivan/go:/usr/local/share/go
ENV PATH /home/ivan/go/bin:$PATH
# RUN cd $HOME/.vim/bundle/YouCompleteMe && sudo -Hi -u ivan zsh -c ./install.sh --clang-completer --gocode-completer
