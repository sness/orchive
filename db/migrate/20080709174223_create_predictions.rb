class CreatePredictions < ActiveRecord::Migration
  def self.up
    create_table :predictions do |t|
      t.text :data, :limit => 2.megabytes
      t.string :name
      t.integer :status # 0 - not run, 1 - in progress, 2 - done

      # Foreign keys
      t.references :user
      t.references :recording

      t.timestamps
    end
  end

  def self.down
    drop_table :predictions
  end
end
