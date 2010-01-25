class CreateItemVideos < ActiveRecord::Migration
  def self.up
    create_table :item_videos do |t|
      t.string :name
      t.string :item_type

      t.timestamps
    end
  end

  def self.down
    drop_table :item_videos
  end
end
