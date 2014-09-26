#!/bin/zsh -l
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

for flac in **/*.flac
do
  echo "converting $flac..."
  OUTF=$(echo "$flac" | sed s/\.flac$/.ogg/g)

  ARTIST=$(metaflac "$flac" --show-tag=ARTIST | sed "s/.*=//g")
  echo "artist: $ARTIST"
  TITLE=$(metaflac "$flac" --show-tag=TITLE | sed "s/.*=//g")
  echo "title: $TITLE"
  ALBUM=$(metaflac "$flac" --show-tag=ALBUM | sed "s/.*=//g")
  echo "album: $ALBUM"
  GENRE=$(metaflac "$flac" --show-tag=GENRE | sed "s/.*=//g")
  echo "genre: $GENRE"
  TRACKNUMBER=$(metaflac "$flac" --show-tag=TRACKNUMBER | sed "s/.*=//g")
  echo "track: $TRACKNUMBER"
  DATE=$(metaflac "$flac" --show-tag=DATE | sed "s/.*=//g")
  echo "date: $DATE"

  flac -c -d "$flac" | oggenc \
    -q 9 \
    --title "$TITLE" \
    --tracknum "${TRACKNUMBER:-0}" \
    --artist "$ARTIST" \
    --album "$ALBUM" \
    --date "$DATE" \
    --genre "${GENRE:-12}" \
    -o "$OUTF" -

  RESULT=$?
  if [ $RESULT -eq 0 ]; then
    rm "$flac"
  fi
done
