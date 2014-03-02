#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2014
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

case `hostname`.strip
when "scabeiathrax"
  puts "starting netcat on typhus..."
  system "ssh typhus.local -- zsh -l -c 'keyboard-listen.sh'"
when "typhus"
  puts "running script on scabeiathrax..."
  system "ssh scabeiathrax.local -- zsh -l -c 'keyboard-send.rb'"
  exit
else
  puts "wtf mate?"
  exit 1
end

ENV["DISPLAY"] = ":0"

ids = []
`xinput`.split("\n").each do |line|
  if line =~ /USB Keyboard/
    ids << line[/id=(\d+)/, 1]
  end
end

status = 0
ids.each do |id|
  `xinput list-props #{id}`.split("\n").each do |line|
    if line =~ /Device Enabled/
      status = [line[/:\s+(\d)/, 1].to_i, status].max
    end
  end
end

puts "status: #{status} (#{ids.join(", ")})"

case status
when 0
  puts "-> scabeiathrax"

  puts "enabling keyboard again..."
  ids.each do |id|
    system "xinput enable #{id}"
  end

  puts "killing netcat..."
  system "killall -q netcat"
when 1
  puts "-> typhus"

  puts "disabling keyboard..."
  ids.each do |id|
    system "xinput disable #{id}"
  end

  puts "sending keyboard events to typhus..."
  system "cat /dev/input/by-id/usb-04d9_USB_Keyboard-event-kbd | netcat typhus.local 4444"
end

puts "done."
