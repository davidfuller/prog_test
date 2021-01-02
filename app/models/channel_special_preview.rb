class ChannelSpecialPreview < ActiveRecord::Base

  belongs_to  :channel
  belongs_to  :special_preview

  def enabled_text
    if enable
      'Enabled'
    else
      ''
    end
  end

end
