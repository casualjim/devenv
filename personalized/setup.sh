#!/bin/zsh
cd $HOME

set -e
set -x
rm -rf $HOME/.vimrc $HOME/.vim $HOME/.antigen $HOME/.emacs.d $HOME/.oh-my-zsh $HOME/.zshrc

export GOPATH=$HOME/go
export GOROOT=/usr/src/go
mkdir -p $GOPATH/src
export PATH=$GOPATH/bin:$PATH

git clone --recursive https://github.com/casualjim/dot-files $HOME/dot-files

curr_dir=$HOME/dot-files
cd $curr_dir
ln -sf ${curr_dir}/vimreboot $HOME/.vim
ln -sf ${curr_dir}/vimreboot/vimrc $HOME/.vimrc
ln -sf ${curr_dir}/ctags $HOME/.ctags
ln -sf ${curr_dir}/antigen $HOME/.antigen
ln -sf ${curr_dir}/zshrc $HOME/.zshrc
ln -sf ${curr_dir}/.tmux.conf $HOME/.tmux.conf
ln -sf ${curr_dir}/gitconfig $HOME/.gitconfig

echo "
antigen theme https://gist.github.com/7585b6aa8d4770866af4.git backchat-remote
export GOROOT=/usr/src/go
" >> $HOME/.zshrc.local

echo '
export GOPATH=$HOME/go:$GOPATH
' >> $HOME/.bash_profile

echo '
---
:verbose: false
:update_sources: true
:sources:
- http://gems.rubyforge.org/
- http://rubygems.org/
gem: --no-ri --no-rdoc --user-install
' > $HOME/.gemrc

env
# vim really wants a tty, it's not available.
# script pretends to have a tty when running the command
# this sources the vimrc which triggers the install of all the plugins
script -qc "vim -e +qall" /dev/null > /dev/null
cd $HOME/.vim/bundle/YouCompleteMe
./install.sh --clang-completer --gocode-completer
set +x
set +e
. $HOME/.zshrc
exit 0
