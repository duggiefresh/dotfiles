# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="bira"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export PATH="/Users/dug/.rbenv/shims:/Users/dug/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/git/bin:/usr/local/bin/npm"

eval "$(rbenv init -)"
export PATH="./bin:./bundler_stubs:./binstubs:$PATH"
export EDITOR=vim

alias n='nvim'
alias nodeversion='n'

alias tmn='tmux new -s'
alias tma='tmux attach -t'
alias tml='tmux ls'
alias tmk='tmux kill-session -t'
alias k='kill -9'

alias gdmb='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'

alias be='bundle exec'
alias psg='ps aux | grep'

alias swp='find . -iname ".*.swp"'
alias killswp='swp | xargs rm'

alias nombom='npm cache clear && bower cache clean && rm -rf node_modules bower_components && npm install && bower install | echo ༼ ºل͟º༼ ºل͟º(  ͡°  ͜ʖ  ͡°)ºل͟º ༽ºل͟º ༽'
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)

man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}
