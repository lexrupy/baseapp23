class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string  :email,                 :limit => 100
      t.string  :login, :limit => 100,  :null => false
      t.string  :crypted_password,      :null => false
      t.string  :password_salt,         :null => false
      t.string  :persistence_token,     :null => false
      t.string  :perishable_token,      :null => false # Activation Code
      t.string  :single_access_token,   :null => false # Private token for feeds, etc
      t.integer :login_count,           :null => false, :default => 0
      t.string  :state,                 :null => false, :default => 'passive'
      t.string  :current_login_ip,      :limit => 60
      t.string  :last_login_ip,         :limit => 60
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.datetime :activated_at
      t.datetime :deleted_at
      t.boolean :master,                :default => false
      t.timestamps
    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table :users
  end
end

