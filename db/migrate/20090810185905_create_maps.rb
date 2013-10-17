class CreateMaps < ActiveRecord::Migration
  def self.up
    create_table :maps do |t|
      t.date :date

      t.string :image_file_path
      t.string :medium_image_file_path

      t.timestamps
    end
  end

  def self.down
    drop_table :maps
  end
end
