#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# sync all git-annex repos
dirs=(~/books ~/音/ ~/テレビ/ ~/games/install)

for dir in $dirs; do
  cd $dir && git-annex sync
done
