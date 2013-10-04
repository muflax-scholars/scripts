#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# grab all preferred data and drop the rest
dirs=(~/txt ~/games/install ~/ongaku/ ~/telebi/)

for dir in $dirs; do
  cd $dir
  git-annex get --auto
  git-annex drop --auto
done
