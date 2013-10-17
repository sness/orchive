class CreateIncidences < ActiveRecord::Migration
  def self.up
    create_table :incidences do |t|
      t.date :date
      t.string :identification
      t.string :acoustic_visual
      t.string :location
      t.string :east_js
      t.string :qcs
      t.string :observer
      t.string :system_info
      t.string :effort
      t.string :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :incidences
  end
end
