class CreateLabbooks < ActiveRecord::Migration
  def self.up
    create_table :labbooks do |t|
      t.string :name           # Usually something like "nov1404-jul0205"
      t.date :start_date
      t.date :end_date
      t.string :pdf_file_path  # PDF for the entire lab book

      t.timestamps
    end
  end

  def self.down
    drop_table :labbooks
  end
end
