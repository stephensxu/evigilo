class CreateChangelog < ActiveRecord::Migration
  def change
    create_table :change_logs do |t|
      t.string :object_name
      t.string :object_id
      t.string :action
      t.json :data
      t.json :snapshot
      t.timestamps
    end
  end
end
