#!/bin/zsh -l

day=$(date "+%Y/%Y-%m-%d")
dest="$HOME/pigs/daily/$day/"
format="%Y-%m-%d_%H-%M_$(hostname).jpg"

if [[ $(pidof X) -gt 0 ]]; then
  mkdir -p $dest
  cd $dest
  DISPLAY=:0.0 scrot -m $format -q 30
fi
