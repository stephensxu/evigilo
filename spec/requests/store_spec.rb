require_relative '../spec_helper'

describe 'Store versions spec' do
  include Rack::Test::Methods

  let(:changelog) do
    ChangeLog.store_change('users', 1, 'create') do |changelog|
      changelog.data = { name: ['Avi', 'NewAvi'] }
    end
  end

  def post_json(uri, json)
    post(uri, json, { "CONTENT_TYPE" => "application/json", format: :json })
  end

  specify 'should store JSON properly with non ascii script' do
    post_json('/store/users/1/create', { data: { description: ["It's something", "It's nothing"] } }.to_json)
    response = JSON.parse(last_response.body)
    expect(response['result']).to eq(true)
  end

  specify 'should store the version correctly' do
    post_json('/store/users/1/create', { data: { name: ['avi', 'newavi'] } }.to_json)
    response = JSON.parse(last_response.body)
    expect(response['result']).to eq(true)
  end

  specify 'should return the version of the change' do
    post_json('/store/users/1/create', { data: { name: ['avi', 'newavi'] } }.to_json)
    response = JSON.parse(last_response.body)
    expect(response['version'].length).to eq(36) ## UUID length
  end

  specify 'returns the correct change for the version' do
    get "versions/#{changelog.version}"
    expect(JSON.parse(last_response.body)['data']).to eq({ 'name' => ['Avi', 'NewAvi'] })
  end

  specify 'returns 404 if the version does not exist' do
    get '/versions/XXXXXXX'
    expect(JSON.parse(last_response.body)['result']).to eq('notok')
  end

  specify 'returns all versions of the object' do
    get "/versions/users/#{changelog.object_id}"
    expect(JSON.parse(last_response.body)['versions'][0]).to eq(changelog.version)
  end

  specify 'returns an empty array for a fake object' do
    get "/versions/some_object/some_fake_id"
    expect(JSON.parse(last_response.body)['versions']).to eq([])
  end
end
