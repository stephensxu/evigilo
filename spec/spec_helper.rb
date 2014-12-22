ENV['RACK_ENV'] = "test"

require File.join(File.dirname(__FILE__), '../evigilo')

set :run, false
set :raise_errors, true
set :logging, false

require 'rubygems'
require 'bundler'
require 'sinatra'
require 'rspec'
require 'rack/test'
require "database_cleaner"

RSpec.configure do |config|
  include Rack::Test::Methods

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  def app
    Evigilo
  end
end
