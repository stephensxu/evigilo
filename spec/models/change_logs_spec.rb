require_relative '../spec_helper'

describe ChangeLog do
  subject { described_class }

  let(:change_hash) do
    { name: ['Avi', 'NewAvi'] }
  end

  it 'stores the data in the correct format' do
    changelog = ChangeLog.store_change('users', 1, 'create') do |log|
      log.data = change_hash
    end
    expect(changelog.data[:name]).to eq(['Avi', 'NewAvi'])
  end

  it 'stores a version UUID' do
    changelog = ChangeLog.store_change('users', 1, 'create') do |log|
      log.data = change_hash
    end
    expect(changelog.version.length).to eq(36) # UUID length
  end

end
