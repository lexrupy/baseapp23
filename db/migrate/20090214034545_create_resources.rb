class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :resource
      t.string :name
      t.string :description
      t.timestamps
    end

    create_table :resources_roles, :id => false do |t|
      t.references :resource
      t.references :role
    end

    create_table :resources_users, :id => false do |t|
      t.references :resource
      t.references :user
    end

  end

  def self.down
    drop_table :resources_roles
    drop_table :resources_users
    drop_table :resources
  end
end
