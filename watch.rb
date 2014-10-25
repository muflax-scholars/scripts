#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "muflax"
require "rb-inotify"

opts = Trollop::options do
  opt :wait,
    "sleep period, in seconds (default 1s unless --changes is specified)",
    :type 	=> :float,
    :short	=> "-t"

  opt :changes,	"watch path for changes",      	:type => :string,	:multi => true
  opt :notify, 	"send notification on changes",	:type => :string

  opt :recursive,	"check paths recursively for changes",           	:default => true
  opt :clear,    	"clear screen upon refresh",                     	:default => true
  opt :kill,     	"kills and restarts process if the path changes",	:default => false

  opt :quiet,	"don't show status messages"

  # don't parse flags for the actual command
  stop_on_unknown
end

Trollop::die "no command specified" if ARGV.empty?

# wait either for the specified time, or 1 second if not in --changes mode
wait = opts[:wait] || (opts[:changes].empty? ? 1 : 0)

def watch files, recursive: true
  notifier = INotify::Notifier.new

  to_watch = files.map do |f|
    if File.directory? f
      f
    else
      File.dirname(f)
    end
  end

  if recursive
    to_watch.dup.each do |dir|
      to_watch += Dir["#{dir}/**/*/"].select{|f| File.directory? f}
    end
  end

  to_watch.uniq!

  to_watch.each do |f|
    notifier.watch(f, :close_write)
  end

  notifier.process

  notifier.close
end

begin
  while true
    begin
      if opts[:clear]
        system "clear"
      end

      pid = Process.spawn("zsh -l -c '#{ARGV.join(" ")}'")

      wait_thread = Thread.new do
        start = Time.now
        Process.wait(pid)

        runtime = Time.now - start

        if opts[:notify]
          system "notify-send '#{opts[:notify]}'"
        end

        duration = if runtime >= 1.hour
                     "%dh%02dm%02ds" % [runtime / 1.hour, runtime % 1.hour, runtime % 1.minute]
                   elsif runtime >= 1.minute
                     "%dm%02ds" % [runtime / 1.minute, runtime % 1.minute]
                   else
                     "%ds" % runtime
                   end

        print "[WAITING (#{duration})]..." unless opts[:quiet]
      end

      # wait for the process by default
      wait_thread.join unless opts[:kill]

      if not opts[:changes].empty?
        watchdog_thread = Thread.new do
          watch opts[:changes], recursive: opts[:recursive]
        end

        watchdog_thread.join
      end

      sleep(wait)

    rescue Interrupt
      # catch the ^C and just abort the running program
      puts "[^C stands for TRY AGAIN]"
      sleep(1)
    end

    # make sure threads are cleanly stopped once we restart
    Thread.list.select{|t| t != Thread.current}.each do |thread|
      thread.kill
    end
    Process.kill(:TERM, pid)
  end
rescue Interrupt
  # end for real
end
