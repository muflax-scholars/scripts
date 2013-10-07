#!/bin/zsh

eclient=$(which emacsclient)
emacs=$(which emacs)
vim=$(which vim)

if [[ ${0:t} == "emacs-gui" ]]; then
  argclient=("-c" "-n")
  argemacs=""
else
  argclient="-nw"
  argemacs="-nw"
fi

# use the daemon if it exists, but fall back on a stand-alone emacs, or vim/vi on crappy systems
if [[ -e $eclient ]]; then
  if [[ -e $emacs ]]; then
    emacsclient $argclient --alternate-editor="emacs $argemacs" $0
  else
    if [[ -e $vim ]]; then
      emacsclient $argclient --alternate-editor='vim' $0
    else
      emacsclient $argclient --alternate-editor='vi' $0
    fi
  fi
else
  if [[ -e $emacs ]]; then
    emacs $argemacs $0 &!
  else
    if [[ -e $vim ]]; then
      vim $0
    else
      vi $0
    fi
  fi
fi
