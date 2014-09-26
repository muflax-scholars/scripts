#!/bin/zsh -l
# Copyright muflax <mail@muflax.com>, 2009
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

for dir in **/*/(N) .
do
    cd $dir
    rename '\s*\(.+?\)\s*' '' *
    rename '\s*\[.+?\]\s*' '' *
    cd -
done

