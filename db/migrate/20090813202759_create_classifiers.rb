class CreateClassifiers < ActiveRecord::Migration
  def self.up
    create_table :classifiers do |t|
      t.string :name
      t.text :mpl
      t.text :arff

      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :classifiers
  end
end
