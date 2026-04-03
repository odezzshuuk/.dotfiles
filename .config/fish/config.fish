set fish_greeting ""

set -g fish_key_bindings fish_vi_key_bindings
set -gx EDITOR nvim
set -gx XDG_CONFIG_HOME $HOME/.config

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

source ~/.config/lf/lfcd.fish

# set lf as lfcd
if type -q lf; and type -q lfcd
    alias lf "lfcd"
    # alias lf "y"
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

# for mode in (bind -L)
#     bind -M $mode ctrl-r fzf_command_history # Bind for peco select history to Ctrl+R
#     bind -M $mode ctrl-f fzf_change_directory # Bind for peco change directory to Ctrl+F
# end
# bind for insert and default mode 
bind -M insert ctrl-r fzf_command_history
bind -M insert ctrl-f fzf_change_directory
bind ctrl-r fzf_command_history
bind ctrl-f fzf_change_directory
# bind ctrl-s fish_test

# -M bind to vim insert mode
bind -M insert ctrl-space 'forward-char'

if status is-interactive
    # Commands to run in interactive sessions can go here
end

stty discard undef

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

starship init fish | source
