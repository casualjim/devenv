export SHELL=/bin/zsh
export OS=`uname`

if [ `id -u` = 0 ]; then
  ZGEN_DIR=/usr/share/zsh/scripts/zgen
fi

zmodload zsh/terminfo
fpath+=("/usr/local/share/zsh/site-functions")

. /usr/share/zsh/scripts/zgen/zgen.zsh

COMPLETION_WAITING_DOTS="true"
DISABLE_CORRECTION="true"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

if ! zgen saved; then
  echo "Creating zgen init"

  zgen oh-my-zsh

  # ZSH plugin enhances the terminal environment with 256 colors.
  zgen load chrissicool/zsh-256color

  # Syntax highlighting bundle.
  zgen load zsh-users/zsh-syntax-highlighting

  # nicoulaj's moar completion files for zsh
  zgen load zsh-users/zsh-completions src

  # git support
  zgen oh-my-zsh plugins/git

  # rsync completion
  zgen oh-my-zsh plugins/rsync

  # docker completion
  zgen oh-my-zsh plugins/docker

  # httpie completion
  zgen oh-my-zsh plugins/httpie

  # Go command completion
  zgen oh-my-zsh plugins/golang

  # cp completion
  zgen oh-my-zsh plugins/cp

  # colorize
  # use pygments to highlight files by extenstion
  # also colorize man pages
  zgen oh-my-zsh plugins/colorize
  zgen oh-my-zsh plugins/colored-man

  # extraction helpers
  zgen oh-my-zsh plugins/extract

  # fish like history search
  zgen load zsh-users/zsh-history-substring-search

  zgen load https://gist.github.com/7585b6aa8d4770866af4.git backchat-remote
  zgen save
fi

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey ' ' magic-space  # also do history expansion on space
