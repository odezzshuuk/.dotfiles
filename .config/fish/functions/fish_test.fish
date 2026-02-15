function fish_test
    set dirs (ls -ad $HOME/.config/*)
    if test -n "$dirs"
      realpath $dirs | grep -v -w "\.git"
    end
end
