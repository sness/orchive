class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :name    # The name of the job
      t.integer :state  # 0 - not run, 1 - in progress, 2 - done

      # Foreign keys
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
