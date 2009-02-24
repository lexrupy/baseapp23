class Announcement < ActiveRecord::Base
  def self.current_announcements(hide_time)
    with_scope :find => {:conditions => ["starts_at <= ? AND ends_at >= ?",Time.now.utc, Time.now.utc], :order => :created_at} do
      unless hide_time.is_a? Time
        find(:all)
      else
        find(:all, :conditions => ["updated_at > ? OR starts_at > ?", hide_time.utc, hide_time.utc])
      end
    end
  end
end
