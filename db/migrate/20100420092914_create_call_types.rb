class CreateCallTypes < ActiveRecord::Migration
  def self.up
    create_table :call_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :call_types
  end
end
