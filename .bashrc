#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export EDITOR='nvim'

LFCD="~/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
    source "$LFCD"
fi

alias lf='lfcd'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

if command -v lazygit &> /dev/null; then
    alias lzdot='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
fi

alias editdot='GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME nvim $HOME'

