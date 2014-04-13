desc "compile go scripts"
task :go do
  go_dir = "#{__dir__}/go"
  Dir["#{go_dir}/*.go"].sort.each do |go|
    sh "cd #{go_dir}; go build #{go}"
  end
end

desc "deploys ALL the things"
task :deploy => [:go] do
  sh "git push"
end

task :default => :deploy
