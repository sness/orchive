class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :first_name,                :string
      t.column :last_name,                 :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime

      # Permissions
      t.column :admin,                     :boolean
      t.column :can_annotate,              :boolean
      t.column :can_set_recording_time,    :boolean
      t.column :can_set_labbook_page,      :boolean

      # Media server
      t.column :mediaserver_url,           :string
      t.column :mediaserver_active,        :boolean
    end
  end

  def self.down
    drop_table "users"
  end
end
