require 'sinatra'
require 'sinatra/activerecord'
require './environments'

Dir.glob('./{models,helpers,controllers}/*.rb').each { |file| require file }

class Evigilo < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  post '/store/:table_name/:id/:action' do
    content_type :json

    changelog = ChangeLog.store_change(params[:table_name], params[:id], params[:action]) do |changelog|
      changelog.data     = params[:data]
      changelog.snapshot = params[:snapshot]
    end

    { result: !changelog.new_record?, version: changelog.version }.to_json
  end

  get '/versions/:table_name/:id' do
    content_type :json
    versions = ChangeLog.where(object_name: params[:table_name], object_id: params[:id]).pluck(:version)

    { result: 'ok', versions: versions }.to_json
  end

  get '/versions/:version' do
    content_type :json

    changelog = ChangeLog.where(version: params[:version]).first

    if changelog
      { result: 'ok', data: changelog.data, snapshot: changelog.snapshot }.to_json
    else
      halt 404, "Version was not found"
    end

  end
end
