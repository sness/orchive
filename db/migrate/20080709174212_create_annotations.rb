class CreateAnnotations < ActiveRecord::Migration
  def self.up
    create_table :annotations do |t|
      t.integer :start_time_ms
      t.integer :end_time_ms
      t.string :label
      t.text :comments

      # Foreign keys
      t.references :user
      t.references :recording

      t.timestamps
    end
  end

  def self.down
    drop_table :annotations
  end
end
