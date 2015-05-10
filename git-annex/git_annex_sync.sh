#!/bin/zsh -l
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# sync all git-annex repos
for dir in $(cat ~/.git_annex_dirs); do
  echo $dir...
  cd $HOME/$dir
  # git-annex add
  git-annex sync
done
