class ChannelTrailer < ActiveRecord::Base

  belongs_to  :channel
  belongs_to  :trailer

  
  def enabled_text
    if enable
      'Enabled'
    else
      ''
    end
  end

end
