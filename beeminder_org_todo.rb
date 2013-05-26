#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "awesome_print"
require "beeminder"
require "date"
require "highline/import"
require "org-ruby"
require "trollop"
require "yaml"

opts = Trollop::options do
  opt :pretend, "don't send data"
  opt :force,   "don't ask for confirmation, just update"
  opt :auto,    "automatically update when updates seem safe"
end

# where to get the todos from
goal_dir = File.expand_path "~/projects/" 
goals = {
         :mavothi       => "languages/mavothi.org",
         :grammar       => ["languages/japanese.org",
                            "languages/french.org",
                            "languages/latin.org"],
         :studienarbeit => "job/hiwi.org",
         :steno         => "steno/steno.org",
         :music         => "music/music.org",
        }

# simple handling of todos
class Orgmode::Headline
  def todo?
    ["TODO", "WAITING"].include? self.keyword
  end

  def done?
    ["DONE"].include? self.keyword
  end
end

# beeminder account
puts "logging into beeminder..."
config    = YAML.load File.open("#{Dir.home}/.beeminderrc")
bee       = Beeminder::User.new config["token"]
bee_goals = bee.goals

# check all goals and update beeminder goal if necessary
goals.each do |goal, files|
  puts
  puts "getting data for #{goal}..."
  bee_goal = bee_goals.find {|g| g.slug == goal.to_s}
  cur_goal = bee_goal.curval.to_i
  tot_goal = bee_goal.goalval.to_i

  files = [*files]
  todo  = done = 0
  files.each do |file|
    org   = Orgmode::Parser.new(File.open(File.join(goal_dir, file)).read)
    todo += org.headlines.count(&:todo?)
    done += org.headlines.count(&:done?)
  end
  total = todo + done

  puts "#{goal} has #{todo} open tasks, and done #{done} out of #{total} total."
  puts "Current Beeminder state is #{cur_goal} of #{tot_goal}."

  if tot_goal != total
    if (opts[:force] or
        (opts[:auto] and total > tot_goal and (DateTime.now < bee_goal.losedate)) or
        (not opts[:auto] and agree "Update goal total from #{tot_goal} to #{total}?"))
      
      puts "updating road to #{total}..."
      bee_goal.dial_road "goalval" => total, "rate" => bee_goal.rate unless opts[:pretend]
    end
  end

  if cur_goal != done
    diff = done - cur_goal
    if (opts[:force] or
        (opts[:auto] and diff > 0 and (DateTime.now < bee_goal.losedate)) or
        (not opts[:auto] and agree "Send diff of #{diff} as datapoint?"))
      
      puts "sending diff of #{diff}..."
      dp = Beeminder::Datapoint.new :value => diff, :comment => "todo diff (#{done} total)" 
      bee_goal.add dp unless opts[:pretend]
    end
  end
end
