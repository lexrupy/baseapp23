class CreateResourceGroups < ActiveRecord::Migration
  def self.up
    create_table :resource_groups do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :resource_groups
  end
end
