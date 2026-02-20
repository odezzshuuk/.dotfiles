#
# ~/.bashrc
#
export PATH="$PATH:$HOME/.local/bin"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export EDITOR='nvim'

LFCD="$HOME/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
    source "$LFCD"
    alias lf='lfcd'
fi

dotfiles() {
  local git_dir="$HOME/.dotfiles/"
  local work_tree="$HOME"

  case "$1" in
    git)
      shift
      command git --git-dir="$git_dir" --work-tree="$work_tree" "$@"
      ;;
    lazygit)
      shift
      command lazygit --git-dir="$git_dir" --work-tree="$work_tree" "$@"
      ;;
    edit)
      local target_path="$work_tree"
      if [ -n "$2" ]; then
        target_path="$2"
      fi
      echo "Opening $target_path with dotfiles git context..."
      GIT_DIR="$git_dir" GIT_WORK_TREE="$work_tree" nvim "$target_path"
      ;;
    *)
      echo "Usage: dotfiles {git|lazygit|edit} [args...]"
      return 1
      ;;
  esac
}

bind -x '"\C-f": fzf_change_directory'


. "$HOME/.cargo/env"
