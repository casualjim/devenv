FROM casualjim/godev:1.5
MAINTAINER Ivan Porto Carrero

ENV PATH /go/bin:/usr/local/bin:$PATH

RUN set -ex \
  && apk --update add ncurses sudo \
  && git clone https://github.com/tarjoilija/zgen /usr/share/zsh/scripts/zgen \
  && adduser -D -s /bin/zsh eng \
  && touch /home/eng/.zshrc \
  && echo 'eng ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/eng \
  && cd /home/eng \
  && git clone --recursive https://github.com/casualjim/dot-files \
  && cd /home/eng/dot-files \
  && ln -sf /home/eng/dot-files/vimreboot /home/eng/.vim \
  && ln -sf /home/eng/dot-files/vimreboot/vimrc /home/eng/.vimrc \
  && ln -sf /home/eng/dot-files/ctags /home/eng/.ctags \
  && ln -sf /home/eng/dot-files/zshrc /home/eng/.zshrc \
  && ln -sf /home/eng/dot-files/.tmux.conf /home/eng/.tmux.conf \
  && ln -sf /home/eng/dot-files/gitconfig /home/eng/.gitconfig
  \
  && cd /home/eng \
  && sudo -Hi -u eng script -qc "vim -e +qall" /dev/null > /dev/null \
  && cd /home/eng/.vim/bundle/YouCompleteMe \
  && ./install.py --clang-completer --gocode-completer


WORKDIR /home/eng
ENV GOPATH /home/eng/go:/usr/local/share/go
ENV PATH /home/eng/go/bin:$PATH
# RUN cd /home/eng/.vim/bundle/YouCompleteMe && ./install.py --clang-completer --gocode-completer
