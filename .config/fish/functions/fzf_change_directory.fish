function fzf_change_directory
  _fzf_change_directory | fzf | read foo
  printf "$foo"
  if test -n "$foo"
    cd "$foo"
    commandline -f repaint
  else 
    commandline ''
  end
end

function _fzf_change_directory
  # set directory search range
  begin
    # config directory
    echo $HOME/.config

    # ghq directory
    ghq list -p  

    # current directory 
    # set -l dirs (fd . --type d -d 1)
    # if test -n "$dirs"
    #   realpath $dirs | grep -v -w "\.git"
    # end

    # Code directory
    set -l dirs (fd . --full-path "$HOME/Code/" --type d --max-depth 3 --unrestricted)
    if test -n "$dirs"
      realpath $dirs | grep -v -w "\.git"
    end
  end
end

