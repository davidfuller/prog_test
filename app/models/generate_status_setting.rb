class GenerateStatusSetting < ActiveRecord::Base

  belongs_to :channel
  default_scope :order => "channel_order"


  def self.find_prefix(sheet_short_filename)
    channels = all(:conditions => { :enabled => true})
    channels.find do |channel|
      sheet_short_filename.starts_with?(channel.prefix)
    end
  end

end
