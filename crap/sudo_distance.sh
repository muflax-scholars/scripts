#!/bin/zsh -l
# Copyright muflax <mail@muflax.com>, 2010
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

last=0
time_covered=0

for t in $(grep -P "sudo .+" ~/.zsh_history | grep -oP "^: \d+" | cut -c 3-); do
    distance=$(( ($t - $last) / 60.0 ))
    if [[ $last -eq 0.0 ]]; then
        start=$t
    else
        if [[ $distance -gt 5.0 ]]; then
            time_covered=$(( $time_covered + 5.0 ))
        else
            time_covered=$(( $time_covered + $distance ))
        fi
    fi
    last=$t
    total=$(( ($last - $start) / 60.0 ))
    #echo "$time_covered, $total"
done

printf "%0.1f / %0.1f = %0.2f%%" $time_covered $total $(( 100 * $time_covered / $total ))
