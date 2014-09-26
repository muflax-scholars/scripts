#!/bin/zsh -l
setopt extendedglob

function common() {
    amixer set Master -q 45%
    xset dpms force on
    killall xlock 2> /dev/null
}

function video() {
    export DISPLAY=:0.1 
    SHOW="ONE PIECE"
    PATTERN="第<->話.^done"

    SHOWPATH='"/home/amon/テレビ/$SHOW"'
    EP=$(eval "ls -1 $SHOWPATH/$PATTERN" | head -1)

    # play stuff
    common
    sleep 3
    mplayer -quiet -really-quiet "$EP" &> /dev/null
    mv "$EP" "${EP:r}.done"
}

function music() {
    export MPD_HOST=192.168.1.15
    SONG="音楽/9mm Parabellum Bullet/Vampire"

    mpc -q clear
    mpc -q add $SONG
    mpc -q repeat on
    mpc -q consume off
    
    # let's go
    common
    mpc -q play
}

function beep() {
    common
    sleep 3
    mplayer -quiet -really-quiet "/home/amon/.wakeup" &> /dev/null
}

beep
