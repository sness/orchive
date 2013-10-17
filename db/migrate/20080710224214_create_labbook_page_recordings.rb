class CreateLabbookPageRecordings < ActiveRecord::Migration
  def self.up
    create_table :labbook_page_recordings do |t|
      t.references :labbook_page
      t.references :recording
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :labbook_page_recordings
  end
end
