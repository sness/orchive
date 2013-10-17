class CreateRecordingStartTimes < ActiveRecord::Migration
  def self.up
    create_table :recording_start_times do |t|
      t.datetime :start_time          # Start of the recording

      # Foreign keys
      t.references :recording
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :recording_start_times
  end
end
