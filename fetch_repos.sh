#!/bin/zsh -l
# Copyright muflax <mail@muflax.com>, 2014
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# update all repos without changing the working tree

autoload colors
if [[ ${terminfo[colors]} -ge 8 ]] then
  colors
fi

for repo in ~/src/**/.git(/); do
  cd $repo/..

  echo "fetching $fg[cyan]$(pwd)$reset_color..."
  for remote in $(git remote); do
    git fetch $remote --recurse-submodules
  done

  case $1 in
    "gc")
      git gc
      git submodule foreach "git gc || true"
      ;;
    "fsck")
      git fsck
      git submodule foreach "git fsck || true"
      ;;
    *)
      git gc --auto
      git submodule foreach "git gc --auto || true"
      ;;
  esac

  if [[ -e ".git/svn" ]]; then
    git svn fetch
  fi

  if [[ -e ".git/annex" ]]; then
    git annex sync
  fi
done
