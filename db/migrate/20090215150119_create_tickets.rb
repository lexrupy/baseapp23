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

    create_table :tickets_users, :id => false do |t|
      t.references :ticket
      t.references :user
    end
  end

  def self.down
    drop_table :tickets
    drop_table :tickets_users
  end
end

