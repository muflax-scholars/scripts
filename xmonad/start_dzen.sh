#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2009
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# initalizes dzen bars

HOSTNAME=$(hostname)

# dzen values
FG="#ffffff"
BG="#000000"
FN="-mplus-gothic-medium-r-*-12-*"
E="sigusr1=raise;sigusr2=lower"
H="13"

#FIXME: stupid, read it out somehow :)
case $HOSTNAME in
  azathoth)
    WIDTH="1920"
    HEIGHT="1200"
    ;;
  nyarlathotep)
    WIDTH="1440"
    HEIGHT="900"
    ;;
  typhus)
    WIDTH="1281"
    HEIGHT="800"
    ;;
  scabeiathrax)
    WIDTH="1281"
    HEIGHT="800"
    ;;
  *)
    echo "unknown host: aborting"
    exit 1
    ;;
esac

DZEN="dzen2 -p -fg '$FG' -bg '$BG' -fn '$FN' -e '$E' -h '$H' -y '$(($HEIGHT - $H))'" 
DZEN_LEFT="$DZEN -x '0' -w '$(($WIDTH / 3))' -ta 'l'"
DZEN_RIGHT="$DZEN -x '$(( $WIDTH / 3))' -w '$(( ($WIDTH / 3) * 2))' -ta 'r'"

# make 2 pipes - one for xmonad's output and one for the status bar
XPIPE=~/.xmonad/xmonad-pipe
SPIPE=~/.xmonad/status-pipe

PIPES=($XPIPE $SPIPE)
for pipe in $PIPES; do
  if [[ -e $pipe && -p $pipe ]]; then
    echo "reusing pipe '$pipe'..."
  else
    rm -f $pipe
    mkfifo -m 600 $pipe
    [ -p $pipe ] || { echo "Ceci n'est pas une pipe."; exit 1 }
  fi
done

# kill all old dzens
killall -q dzen2

# launch xmonad's dzen
eval "$DZEN_LEFT < $XPIPE &"

# launch status dzen
eval "$DZEN_RIGHT < $SPIPE &"
