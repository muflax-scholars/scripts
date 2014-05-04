#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2014
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# update all repos without changing the working tree

autoload colors
if [[ ${terminfo[colors]} -ge 8 ]] then
  colors
fi


for repo in ~/src/**/.(git|hg)(/); do
  cd $repo/..

  echo "fetching $fg[cyan]$(pwd)$reset_color..."
  case $repo in
    */.git)
      for remote in $(git remote); do
        git fetch $remote
      done
      git gc --auto
      ;;
    */.hg)
      hg pull
      ;;
  esac
done
