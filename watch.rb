#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "trollop"
require "rb-inotify"

opts = Trollop::options do
  opt :wait,
    "sleep period, in seconds (default 1s unless --changes is specified)",
    type: 	:float,
    short:	"-t"

  opt :changes,	"watch path for changes",          	type: :string,	multi: true
  opt :exclude,	"exclude paths from being watched",	type: :string,	multi: true
  opt :notify, 	"send notification on changes",    	type: :string

  opt :recursive,	"check paths recursively for changes",           	default: true
  opt :clear,    	"clear screen upon refresh",                     	default: true
  opt :kill,     	"kills and restarts process if the path changes",	default: false

  opt :quiet,	"don't show status messages"

  # don't parse flags for the actual command
  stop_on_unknown
end

Trollop::die "no command specified" if ARGV.empty?

# wait either for the specified time, or 1 second if not in --changes mode
wait = opts[:wait] || (opts[:changes].empty? ? 1 : 0)

def watch files, recursive: true, exclude: []
  notifier = INotify::Notifier.new

  to_watch = files.map do |f|
    File.directory?(f) ? f : File.dirname(f)
  end

  if recursive
    to_watch += to_watch.flat_map do |dir|
      Dir["#{dir}/**/*/"].select{|f| File.directory? f}
    end
  end

  begin
    to_watch.uniq.each do |f|
      notifier.watch(f, :close_write, :move) do |event|
        file = event.absolute_name

        # don't stop the watch if the file is excluded
        notifier.stop unless exclude.any?{|ex| file =~ ex}
      end
    end
  rescue SystemCallError => e
    # in case of error, just stop the notifier
    notifier.close
    raise e
  end

  notifier.run
end

begin
  exclude = opts[:exclude].map{|e| Regexp.new(e)}

  while true
    begin
      system "clear" if opts[:clear]

      pid = Process.spawn("zsh -l -c '#{ARGV.join(" ")}'")

      wait_thread = Thread.new do
        start = Time.now
        Process.wait(pid)

        runtime = Time.now - start

        system "notify-send '#{opts[:notify]}'" if opts[:notify]

        duration = if runtime >= (60*60)
                     "%dh%02dm%02ds" % [runtime / (60*60),
                                        (runtime % (60*60)) / 60,
                                        runtime % 60]
                   elsif runtime >= 60
                     "%dm%02ds" % [runtime / 60,
                                   runtime % 60]
                   else
                     "%ds" % runtime
                   end

        print "[WAITING (#{duration})]..." unless opts[:quiet]
      end

      # wait for the process by default
      wait_thread.join unless opts[:kill]

      if not opts[:changes].empty?
        watchdog_thread = Thread.new do
          begin
            watch opts[:changes], recursive: opts[:recursive], exclude: exclude
          rescue SystemCallError => e
            # throw an error, but continue anyway
            STDERR.print "[some bullshit happened]"
            # warn e.inspect
            # warn e.backtrace
          end
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
    begin
      Process.kill(:TERM, pid)
      Process.wait(pid)
    rescue Errno::ESRCH
      # process already terminated, don't care
    end
  end
rescue Interrupt
  # end for real
end
