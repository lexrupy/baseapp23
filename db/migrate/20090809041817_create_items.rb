class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.string :description
      t.string :item_type
      t.string :item_role
      t.string :user
      t.string :item_model
      t.string :serial
      t.string :manufacturer
      t.string :operating_system
      t.string :ip_address
      t.string :subnet
      t.string :dhcp
      t.integer :memory
      t.integer :disk
      t.string :video
      t.string :display
      t.string :optical_drive
      t.string :processor
      t.string :item_status
      t.string :location
      t.string :supplier
      t.decimal :cost
      t.datetime :guarantee
      t.string :document
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end

