#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

dirs=(~/txt ~/ongaku/ ~/telebi/ ~/games/install)

for dir in $dirs; do
  cd $dir
  git-annex watch || true
done
