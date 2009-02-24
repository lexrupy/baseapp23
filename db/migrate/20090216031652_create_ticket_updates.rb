class CreateTicketUpdates < ActiveRecord::Migration
  def self.up
    create_table :ticket_updates do |t|
      t.references :ticket
      t.references :user
      t.string :assigned_change
      t.string :status_change
      t.string :category_change
      t.string :priority_change
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :ticket_updates
  end
end
