class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
    end

    # generate the join table
    create_table :roles_users, :id => false do |t|
      t.references :role
      t.references :user
    end

  end

  def self.down
    drop_table :roles
  end
end
