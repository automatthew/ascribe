require "starter/tasks/bootstrap"
require "starter/tasks/npm"
require "starter/tasks/git"
require "starter/tasks/github"
require "starter/tasks/markdown"

task "build" do
  sh "coffee -c -o ./ ascribe.coffee"
end

task "test" => "data" do
  sh "coffee test/ascribe_test"
end

task "data" do
  require "json"
  data = []
  2000.times do |i|
    data << (i % 400) * rand(10)
  end
  File.open("test/data.json", "w") do |f|
    f.puts data.to_json
  end
end

