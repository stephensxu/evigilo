require_relative '../spec_helper'

describe 'Store versions spec' do
  include Rack::Test::Methods

  specify 'should store the version correctly' do
    post '/store/users/1/create', params: { data: { name: ['Avi', 'NewAvi'] } }
    expect(JSON.parse(last_response.body)['result']).to eq(true)
  end

  specify 'should return the version of the change' do
    post '/store/users/1/create', params: { data: { name: ['Avi', 'NewAvi'] } }
    expect(JSON.parse(last_response.body)['version'].length).to eq(36) # UUID length
  end

  specify 'returns the correct change for the version' do

  end
end
