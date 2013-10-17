class CreateLabbookPages < ActiveRecord::Migration
  def self.up
    create_table :labbook_pages do |t|
      t.date    :start_date  # start_date and end_date will usually be the same day, or a day apart
      t.date    :end_date    
      t.integer :page

      t.string :image_file_path
      t.string :medium_image_file_path
      t.string :small_image_file_path
      t.string :thumbnail_image_file_path

      t.text :page_text # The full text of the page

      # Foreign keys
      t.references :labbook

      t.timestamps
    end
    
  end

  def self.down
    drop_table :labbook_pages
  end
end
