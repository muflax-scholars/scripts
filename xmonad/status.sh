#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# Shows some nice status bar.

# global variables
hostname=$(hostname)
fume_db=$(ruby -ryaml << EOF
  c = YAML.load_file(File.join(ENV['HOME'], '.fumerc'))
  puts File.join(c['fume_dir'], 'fume_db.yaml')
EOF
)
export last_mod_time=0

# processes with >= 30% cpu load
cpu_hogs() {
  ps -eo pcpu,ucmd --sort -pcpu | grep -vP "migration/\d+" | tail -n +2 | while read proc
  do
    if [[ $proc[(w)1] -ge 30.0 ]] then
      echo -n " $proc[(w)1] ${${proc[(w)2]}[1,10]}"
    fi
  done
}

status() {
  # widgets are output in order
  integer dzen_number=200

  # processes with >= 50% cpu load
  echo "$dzen_number P$(cpu_hogs)"
  dzen_number+=1

  # battery status
  echo "$dzen_number B ${$(acpi)[(w)4,-1]}"
  dzen_number+=1

  # current load
  load=($(cat /proc/loadavg))
  echo "$dzen_number L $load[1,3]"
  dzen_number+=1
  
  # memory usage
  mem=(${$(free -m | grep "Mem:")[2,7]})
  printf "$dzen_number M %4d\n" $(($mem[2] - $mem[5] - $mem[6]))
  dzen_number+=1

  # volume
  mixer="Master"
  volume=$(amixer get $mixer | grep -oP '\d+%' | tail -1)
  headphone_mixer="Headphone"
  headphone=" $(amixer get $headphone_mixer | grep -oP '\[(on|off)\]' | tail -1)"
  echo "$dzen_number V ${volume}${headphone}"
  dzen_number+=1

  # current date
  us_time=$(TZ="America/Los_Angeles" date "+u:%H")
  mom_time=$(TZ="Europe/Berlin" date "+m:%H")
  local_time=$(date "+%a %d [${us_time}|${mom_time}] %H時%M分%S秒")
  echo "$dzen_number $local_time"
  dzen_number+=1
}

# watches fume database for changes to prevent unnecessary execs
watch_fume() {
  mod_time=$(stat -c "%Y" $fume_db)
  now=$(date "+%s")
  
  if [[ $mod_time -gt $last_mod_time ]]; then
    last_mod_time=$mod_time
    ti display --start 'today 0:00' -f status
  elif [[ $now -gt $(( $last_mod_time + 600 )) ]]; then
    last_mod_time=$now
    ti display --start 'today 0:00' -f status
  fi
}

if [[ $1 != "debug" ]]; then
  while true
  do 
    { status; sleep 0.9s } &
    watch_fume # note: this can't be &-ed as it writes a global variable
    wait
  done | dmplex
else
  status | dmplex
fi
