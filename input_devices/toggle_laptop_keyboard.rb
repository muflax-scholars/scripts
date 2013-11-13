#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

devices = [
           "Internal Keyboard"
          ]

id = nil

`xinput`.split("\n").each do |line|
  if line =~ /(#{devices.join("|")})/
    id = line[/id=(\d+)/, 1]
    break
  end
end

puts id

if id
  `xinput list-props #{id}`.split("\n").each do |line|
    if line =~ /Device Enabled/
      status = line[/:\s+(\d)/, 1]
      case status
      when "0" # enable keyboard
        system "xinput enable #{id}"
      when "1" # disable keyboard
        system "xinput disable #{id}"
      else
        puts "weird device state: #{status}"
      end
    end
  end
else
  puts "couldn't find any keyboard to disable"
end
