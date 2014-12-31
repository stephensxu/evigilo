require 'sinatra'
require 'sinatra/activerecord'
# require 'multi_json'
# require 'json'
require 'json/pure'

class Evigilo < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  require './environments'

  unless ENV['RACK_ENV'] == 'test'
    use Rack::Auth::Basic, "Protected Area" do |username, password|
      username == settings.username && password == settings.password
    end
  end

  Dir.glob('./{models,helpers,controllers}/*.rb').each { |file| require file }

  Dir["#{settings.config_directory}/**/*.rb"].sort.each do |file_path|
    require File.join(Dir.pwd, file_path)
  end

  get '/' do
    content_type :json
    { result: 'ok', count: ChangeLog.count }.to_json
  end

  post '/store/:table_name/:id/:action' do
    p "this is using json_pure parser"
    request_payload = JSON[(request.env["rack.input"].read)]

    changelog = ChangeLog.store_change(params[:table_name], params[:id], params[:action]) do |changelog|
      changelog.data     = request_payload['data']
      changelog.snapshot = request_payload['snapshot'] || {}
    end

    { result: !changelog.new_record?, version: changelog.version }.to_json
  end 

  get '/versions/:table_name/:id' do
    content_type :json

    versions = ChangeLog.where(object_name: params[:table_name], object_id: params[:id]).pluck(:version)
    { result: 'ok', versions: versions }.to_json
  end

  get '/versions/:version' do
    p "this is debugging branch"
    content_type :json

    changelog = ChangeLog.where(version: params[:version]).first
    if changelog
      { result: 'ok',
        object_name: changelog.object_name,
        object_id: changelog.object_id,
        data: changelog.data,
        snapshot: changelog.snapshot
      }.to_json
    else
      { result: 'notok', message: 'version was not found' }.to_json
    end
  end
end
