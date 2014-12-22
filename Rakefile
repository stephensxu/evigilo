require 'sinatra/activerecord/rake'
require './evigilo'

if ENV['RACK_ENV'] == 'test'
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new :specs do |task|
    task.pattern = Dir['spec/**/*_spec.rb']
  end
end

task :default => ['specs']
