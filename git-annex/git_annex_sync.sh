#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# sync all git-annex repos
dirs=(~/txt ~/音/ ~/テレビ/ ~/games/install)

for dir in $dirs; do
  echo $dir...
  cd $dir && git-annex add && git-annex sync
done
