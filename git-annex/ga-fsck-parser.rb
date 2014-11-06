#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2014
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "muflax"

ARGV.each do |file|
  lines = []
  File.load(file).each do |line|
    case line
    when "ok\n"
      lines.pop
    else
      lines << line
    end
  end

  File.save("#{file}.filtered") do |f|
    f.puts lines
  end
end
