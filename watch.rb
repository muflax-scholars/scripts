#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "muflax"
require "rb-inotify"

opts = Trollop::options do
  opt :wait,
    "sleep period, in seconds (default 1s unless --changes is specified)",
    :type => :float,
    :short => "-t"
  opt :changes,
    "watch path for changes",
    :type => :string,
    :multi => true
  opt :notify,
    "send notification on changes",
    :type => :string
  opt :clear,
    "clear screen upon refresh",
    :default => true

  # don't parse flags for the actual command
  stop_on_unknown
end

Trollop::die "no command specified" if ARGV.empty?

# wait either for the specified time, or 1 second if not in --changes mode
wait = opts[:n] || (opts[:changes].empty? ? 1 : 0)


def watch files
  notifier = INotify::Notifier.new

  files.each do |file|
    notifier.watch(file, :close_write)
  end

  notifier.process

  notifier.close
end

begin
  while true
    if opts[:clear]
      system "clear"
    end

    system "zsh -l -c '#{ARGV.join(" ")}'"

    if not opts[:changes].empty?
      watch opts[:changes]
    end

    if opts[:notify]
      system "notify-send '#{opts[:notify]}'"
    end

    puts "[WAITING]..."

    sleep(wait)
  end
rescue Interrupt
end
