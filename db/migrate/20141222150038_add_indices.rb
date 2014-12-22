class AddIndices < ActiveRecord::Migration
  def change
    add_index :change_logs, :version
    add_index :change_logs, [:object_name, :object_id]
  end
end
