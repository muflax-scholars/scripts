#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2014
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# update all repos without changing the working tree

autoload colors
if [[ ${terminfo[colors]} -ge 8 ]] then
  colors
fi

for repo in ~/src/**/(.git|.hg|_darcs)(/); do
  cd $repo/..

  echo "fetching $fg[cyan]$(pwd)$reset_color..."
  case $repo in
    */.git)
      for remote in $(git remote); do
        git fetch $remote --recurse-submodules
      done

      if [[ $1 == "gc" ]]; then
        git gc
        git submodule foreach "git gc || true"
      else
        git gc --auto
        git submodule foreach "git gc --auto || true"
      fi

      if [[ -e ".git/svn" ]]; then
        git svn fetch
      fi

      ;;

    */.hg)
      hg pull
      ;;

    */_darcs)
      darcs fetch --all
      ;;
  esac
done