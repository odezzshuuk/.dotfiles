# .dotfiles

## Version Control

```sh
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

## Gist

commit local ~/.editorconfig to update remote .editorconfig at github gist

```sh
gh gist edit 1a8a58ef904447ae273499c342c39bde -a ~/.editorconfig
```

get remote gist `.editorconfig` to local

```sh
curl -L https://gist.githubusercontent.com/odezzshuuk/1a8a58ef904447ae273499c342c39bde/raw/01a12557b41950c6573623d7ad55d9f658989d7a/.editorconfig -o .editorconfig
```

## Local bash script name convention

- `script.sh` for being called by other script 
- `script` for manually call in terminal

