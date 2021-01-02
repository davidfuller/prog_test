class ChannelOnDemand < ActiveRecord::Base

  belongs_to  :channel
  belongs_to  :on_demand

  
  def enabled_text
    if enable
      'Enabled'
    else
      ''
    end
  end

end
