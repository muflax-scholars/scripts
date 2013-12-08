#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

devices = [
  "bcm5974",
  "Synaptics TouchPad",
  "Razer Razer DeathAdder"
]

ids = []

`xinput`.split("\n").each do |line|
  if line =~ /(#{devices.join("|")})/
    ids << line[/id=(\d+)/, 1]
  end
end

if ids.empty?
  puts "couldn't find any mice to disable"
  exit 1
end

status = nil

ids.each do |id|
  `xinput list-props #{id}`.split("\n").each do |line|
    if line =~ /Device Enabled/

      # the first device in the list defines the status of all other devices, so that running the script always leaves all mice in the *same* state
      status ||= line[/:\s+(\d)/, 1]
    end
  end

  case status
  when "0" # enable cursor
    system "xinput enable #{id}"
    system "xsetroot -cursor_name left_ptr"
  when "1" # disable cursor
    system "xinput disable #{id}"
    system "xsetroot -cursor #{__dir__}/invisible_cursor.xbm #{__dir__}/invisible_cursor.xbm"
  else
    puts "weird device state: #{status}"
  end
end
