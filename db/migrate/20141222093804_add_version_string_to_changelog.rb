class AddVersionStringToChangelog < ActiveRecord::Migration
  def change
    add_column :change_logs, :version, :string, length: 36
  end
end
