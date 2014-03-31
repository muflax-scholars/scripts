#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2014
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "muflax"

File.load("~/.go_packages").each do |line|
  next if line.starts_with? "#" or line.blank?

  pkg = line.strip

  puts "getting #{pkg}..."
  system "go get -v -u #{pkg}"
end
