#!/bin/zsh -l
# Copyright muflax <mail@muflax.com>, 2014
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

echo "using $(pwd) as final repo..."
sleep 3
git init

export GIT_DIR=$PWD/.git

for dir in $*; do
  cd $dir
  git add -A .
  git commit -m "import $dir into git"
done

echo "done!"
