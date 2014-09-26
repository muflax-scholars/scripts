#!/bin/zsh -l
# Copyright muflax <mail@muflax.com>, 2012
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# Simple Twitter backup script

source ~/.zsh/env.sh
source ~/.zsh/path.sh

DAY=$(date +'%Y-%m-%d')
DIR="/home/amon/archive/twitter/$DAY/"

mkdir -p $DIR

echo "Backing up tweets..."
twitter timeline @muflax --csv --number 3000 > $DIR/tweets.csv

echo "Backing up retweets..."
twitter retweets --csv --number 3000 > $DIR/retweets.csv
echo "Backing up favorites..."
twitter favorites --csv --number 3000 > $DIR/favorites.csv

echo "Backing up DM received..."
twitter direct_messages --csv --number 3000 > $DIR/dm_received.csv
echo "Backing up DM sent..."
twitter direct_messages_sent --csv --number 3000 > $DIR/dm_sent.csv

echo "Backing up followings..."
twitter followings --csv > $DIR/followings.csv
echo "Backing up followers..."
twitter followers --csv > $DIR/followers.csv

# TODO deal with rate limit
# echo "Backuping up tweets of followings / followings..."
# for f in $(sort -u <(twitter followings) <(twitter followers)); do
#   echo "$f..."
#   twitter timeline "@$f" --csv --number 3000 > $DIR/tweets-$f.csv
# done

echo "Compressing backups..."
gzip -f -9 $DIR/*.csv
