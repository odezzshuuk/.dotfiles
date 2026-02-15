function fzf_change_directory
  _fzf_change_directory | fzf | read dir_path
  printf "$dir_path"
  if test -n "$dir_path"
    cd "$dir_path"
    commandline -f repaint
  else 
    commandline ''
  end
end

function _fzf_change_directory
  # set directory search range
  begin

    # .config/
    ls -ad $HOME/.config/*/ | sed 's|/*$||' # sed 's|/*$||' is for removing trailing slash

    # ghq directory
    ghq list -p  

    # Code/ directory
    fd '^\.git$' "$HOME/Code/" -d 3 -H -I --prune --exec echo {//}
    echo "$HOME/.local/share/wallpapers"
    echo "$HOME/.local/bin"
    ls -ad $HOME/Resources/*/ | sed 's|/*$||'

    # current directory 
    # set -l dirs (fd . --type d -d 1)
    # if test -n "$dirs"
    #   realpath $dirs | grep -v -w "\.git"
    # end

    # old Code/ directory
    # set -l dirs (fd . --full-path "$HOME/Code/" --type d --max-depth 3 --unrestricted)
    # if test -n "$dirs"
    #   realpath $dirs | grep -v -w "\.git"
    # end
  end
end

