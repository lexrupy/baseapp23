class AddNotifyTicketUpdateToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :notify_ticket_update, :boolean
  end

  def self.down
    remove_column :profiles, :notify_ticket_update
  end
end
