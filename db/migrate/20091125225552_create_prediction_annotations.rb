class CreatePredictionAnnotations < ActiveRecord::Migration
  def self.up
    create_table :prediction_annotations do |t|
      t.references :prediction
      t.references :annotation

      t.timestamps
    end
  end

  def self.down
    drop_table :prediction_annotations
  end
end
