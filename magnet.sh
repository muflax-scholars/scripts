#!/bin/zsh -l
# Copyright muflax <mail@muflax.com>, 2012
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# open magnet links
DISPLAY=:0.0 /usr/bin/transmission-qt "$1" &!
