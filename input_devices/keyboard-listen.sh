#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2014
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

killall -q netcat
netcat --listen --local-port=4444 >> /dev/input/by-path/platform-i8042-serio-0-event-kbd &
