set fish_greeting ""

set -gx EDITOR nvim
set -gx XDG_CONFIG_HOME $HOME/.config

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

source ~/.config/lf/lfcd.fish

# set lf as lfcd
if type -q lf; and type -q lfcd
  alias lf "lfcd"
end

if type -q ranger
  alias r "ranger-cd"
end

if type -q eza
  alias ll "eza -l -g --icons"
  alias lla "ll -a"
end

if type -q Unity\ Hub
  alias unity-hub "Unity\ Hub"
end

bind \cr fzf_select_history # Bind for peco select history to Ctrl+R
bind \cf fzf_change_directory # Bind for peco change directory to Ctrl+F
# bind \cs fish_test

# vim-like
bind \cl forward-char

# prevent iterm2 from closing when typing Ctrl-D (EOF)
bind \cd delete-char

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# dotfiles
alias dotfiles "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
if type -q lazygit
  alias dotfileslg "lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
end

stty discard undef

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
