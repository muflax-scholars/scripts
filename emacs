#!/bin/zsh

eclient=$(which emacsclient)
emacs=$(which emacs-24)
vim=$(which vim)

name=${0:t}

if [[ $name == "emacs-gui" ]]; then
  argclient=("-c" "-n")
  argemacs=""
elif [[ $name == "emacs-gui-wait" ]]; then
  argclient=("-c")
  argemacs=""
else
  argclient="-nw"
  argemacs="-nw"
fi

# use the daemon if it exists, but fall back on a stand-alone emacs, or vim/vi on crappy systems
if [[ -e $eclient ]]; then
  if [[ -e $emacs ]]; then
    emacsclient $argclient --alternate-editor="emacs-24 $argemacs" $*
  else
    if [[ -e $vim ]]; then
      emacsclient $argclient --alternate-editor='vim' $*
    else
      emacsclient $argclient --alternate-editor='vi' $*
    fi
  fi
else
  if [[ -e $emacs ]]; then
    emacs-24 $argemacs $* &!
  else
    if [[ -e $vim ]]; then
      vim $*
    else
      vi $*
    fi
  fi
fi
