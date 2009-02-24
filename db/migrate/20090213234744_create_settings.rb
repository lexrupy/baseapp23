class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :label
      t.string :identifier
      t.text   :description
      t.string :field_type, :default => 'string'
      t.text   :value

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
