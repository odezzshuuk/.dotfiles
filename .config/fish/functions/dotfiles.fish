function dotfiles
  set -l git_dir "$HOME/.dotfiles/"
  set -l work_tree "$HOME"

  switch $argv[1]
    case git
      command git --git-dir=$git_dir --work-tree=$work_tree $argv[2..-1]
    case lzgit
      command lazygit --git-dir=$git_dir --work-tree=$work_tree $argv[2..-1]
    case edit
      set -l target_path $work_tree
      if test -n "$argv[2]"
        set target_path $argv[2]
      end
      echo "Opening $target_path with dotfiles git context..."
      env GIT_DIR=$git_dir GIT_WORK_TREE=$work_tree nvim $target_path
    case '*'
      echo "Usage: dotfiles {git|lazygit|edit} [args...]"
      return 1
  end
end
