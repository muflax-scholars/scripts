#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

state = nil

# find state
xset = `xset q`
xset.split("\n").each do |line|
  m = line.match(/auto repeat:\s+(on|off)/)
  if m
    state = m[1]
    break
  end
end

# toggle
state = case state
        when "on"
          "off"
        when "off"
          "on"
        else
          puts "invalid state: #{state}"
          exit 1
        end
system "xset r #{state}"
