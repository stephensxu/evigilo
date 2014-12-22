require 'sinatra/activerecord/rake'
require 'rspec/core/rake_task'
require './evigilo'

RSpec::Core::RakeTask.new :specs do |task|
  task.pattern = Dir['spec/**/*_spec.rb']
end

task :default => ['specs']
