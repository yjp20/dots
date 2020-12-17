source "$HOME/.vim/bundle/gruvbox/gruvbox_256palette.sh"
eval $(dircolors ~/.dircolors)
export EDITOR=vim

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory extendedglob nomatch
unsetopt autocd beep
bindkey -e
zstyle :compinstall filename '/home/youngjin/.zshrc'

autoload -U promptinit; promptinit
autoload -Uz compinit

compinit
prompt pure

G="https://github.com/yjp20"

source ~/dot/shell/alias.sh
PATH+=:~/dot/scripts
PATH+=:~/.go/bin
PATH+=:~/.local/bin
export GOPATH=$HOME/.go

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULES=ibus

export FZF_DEFAULT_COMMAND='fd --type f -E node_modules -E music -E sync/fonts -E go/ -E void-packages '
. /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
