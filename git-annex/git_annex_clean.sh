#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# grab all preferred data
for dir in $(cat ~/.git_annex_dirs); do
  echo $dir...
  cd $HOME/$dir
  git fsck && git gc --aggressive && git prune && \
    git-annex unused && git-annex dropunused 1-10000 --force
done
