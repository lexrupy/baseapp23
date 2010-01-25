class CreateItemUsers < ActiveRecord::Migration
  def self.up
    create_table :item_users do |t|
      t.string :name
      t.string :item_type
      t.string :location

      t.timestamps
    end
  end

  def self.down
    drop_table :item_users
  end
end
