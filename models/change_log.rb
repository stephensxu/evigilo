class ChangeLog < ActiveRecord::Base
  def self.store_change(object_name, object_id, action, version = SecureRandom.uuid)
    ChangeLog.new.tap do |changelog|
      changelog.object_name = object_name
      changelog.object_id = object_id
      changelog.action = action
      changelog.version = version
      yield(changelog) if block_given?
      changelog.save
    end
  end

  def data
    self.read_attribute(:data).with_indifferent_access
  end

end
