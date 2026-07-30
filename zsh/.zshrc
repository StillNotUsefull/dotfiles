ZSH_THEME="catppuccin"
CATPPUCCIN_FLAVOR="mocha"
CATPPUCCIN_SHOW_TIME=true
CATPPUCCIN_SHOW_HOSTNAME="always"

. "$HOME/.local/bin/env"

export ZSH="/usr/share/oh-my-zsh"

DISABLE_MAGIC_FUNCTIONS="true"

ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

[[ -z "${plugins[*]}" ]] && plugins=(git fzf extract)

source $ZSH/oh-my-zsh.sh

export HISTCONTROL=ignoreboth

export HISTORY_IGNORE="(\&|[bf]g|c|clear|history|exit|q|qwd|* --help)"

export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

alias c="clear"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

source /usr/share/doc/pkgfile/command-not-found.zsh

export FZF_BASE=/usr/share/fzf
