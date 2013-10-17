class CreateRecordingComments < ActiveRecord::Migration
  def self.up
    create_table :recording_comments do |t|
      t.text :text
      
      # Foreign keys
      t.references :recording
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :recording_comments
  end
end
