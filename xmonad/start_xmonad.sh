#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2010
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# wrapper to start xmonad + status bars

start_dzen.sh
xmonad > ~/.xmonad/xmonad-pipe &
status.sh > ~/.xmonad/status-pipe &

wait
