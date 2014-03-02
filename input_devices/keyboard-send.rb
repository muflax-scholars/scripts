#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2014
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

if `hostname` != "scabeiathrax"
  system "scab keyboard-send.rb"
  exit
end

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
      status = [line[/:\s+(\d)/, 1].to_i, status].min
    end
  end
end

case status
when 0
  # -> scabeiathrax
  ids.each do |id|
    system "xinput enable #{id}"
  end
  system "killall netcat"
when 1
  # -> typhus
  ids.each do |id|
    system "xinput disable #{id}"
  end
  system "cat /dev/input/by-id/usb-04d9_USB_Keyboard-event-kbd | netcat typhus.local 4444 &"
end
