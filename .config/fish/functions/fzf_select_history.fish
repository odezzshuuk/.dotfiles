function fzf_select_history
  set -l buf (commandline -b)
  if [ $buf ]
    history | fzf --query "$buf" | read selected
  else
    history | fzf | read selected
  end

  if [ $selected ]
    commandline -r $selected
  else
    commandline -r ''
  end
end

