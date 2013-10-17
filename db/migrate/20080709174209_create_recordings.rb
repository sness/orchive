class CreateRecordings < ActiveRecord::Migration
  def self.up
    create_table :recordings do |t|
      # Parameters for the physical tape
      t.string :name
      t.string :tape
      t.string :side
      t.integer :year                 

      # Information from the labbook
      t.datetime :start_time          # When the recording was started
      t.datetime :end_time            # When the recording finished

      # Information about the audio file
      t.integer :length_ms            # The length of the recording in milliseconds
      t.string :wav_audio_file_path   # The path for the massive wav file
      t.string :mp3_audio_file_path   # The path for the 128kbs MP3 file

      t.timestamps
    end
    
    # sness - We will access the year field quite often
    add_index :recordings, :year

  end

  def self.down
    drop_table :recordings
  end
end
