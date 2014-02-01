#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2014
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "active_support/core_ext/numeric"
require "trollop"

# avoid rails deprecation warning
I18n.enforce_available_locales = false

opts = Trollop::options do
  opt :size, "convert to size"
end

to = opts[:size] ? :human_size : :delimited

STDIN.each do |line|
  new_line = line.gsub(/\d+(\.\d+)?/) do |num|
    num = num.include?(".") ? num.to_f : num.to_i
    num.to_s(to)
  end

  puts new_line
end
