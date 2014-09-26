#!/bin/zsh -l
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

source ~/.zsh/env.sh
source ~/.zsh/path.sh

firefox-urls | backup-urls >/dev/null
