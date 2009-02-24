class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer :creator_id
      t.integer :assigned_to_id
      t.string :subject
      t.text :body
      t.string :category
      t.string :status,           :default => 'new'
      t.string :priority,         :default => 'normal'

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
