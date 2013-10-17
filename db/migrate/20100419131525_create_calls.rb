class CreateCalls < ActiveRecord::Migration
  def self.up
    create_table :calls do |t|
      t.string :matriline
      t.string :notes
      t.string :audio
      t.string :image

      t.references :call_type

      t.timestamps
    end
  end

  def self.down
    drop_table :calls
  end
end
