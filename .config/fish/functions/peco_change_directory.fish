function _peco_change_directory

  if [ (count $argv) ]
    peco --layout=bottom-up --query "$argv "|perl -pe 's/([ ()])/\\\\$1/g'| read foo
  else
    peco --layout=bottom-up | perl -pe 's/([ ()])/\\\\$1/g'| read foo
  end

  if [ $foo ]
    builtin cd $foo
    commandline -r ''
    commandline -f repaint
  else
    commandline ''
  end
end

function peco_change_directory
  begin
    echo $HOME/.config
    ghq list -p  # ghq directory
    ls -ad */ | perl -pe "s#^#$PWD/#" | grep -v \.git # current directory
    ls -ad $HOME/Code/Developments/*/* |grep -v \.git # project repo
  end | sed -e 's/\/$//' | awk '!a[$0]++' | _peco_change_directory $argv
end

