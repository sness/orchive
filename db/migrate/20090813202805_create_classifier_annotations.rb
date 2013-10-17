class CreateClassifierAnnotations < ActiveRecord::Migration
  def self.up
    create_table :classifier_annotations do |t|
      t.references :classifier
      t.references :annotation

      t.timestamps
    end
  end

  def self.down
    drop_table :classifier_annotations
  end
end
