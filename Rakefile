desc "compile go scripts"
task :go do
  Dir["#{__dir__}/go/*.go"].sort.each do |go|
    sh "go build #{go}"
  end
end

desc "deploys ALL the things"
task :deploy => [:go] do
  sh "git push"
end

task :default => :deploy
