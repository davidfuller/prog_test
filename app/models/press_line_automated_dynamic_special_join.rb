class PressLineAutomatedDynamicSpecialJoin < ActiveRecord::Base

  belongs_to :press_line
  belongs_to :automated_dynamic_special
  belongs_to :part

  default_scope :include => :part, :order => "parts.order_number"


  def self.last_placing(ads_id, transmission_time)
    PressLineAutomatedDynamicSpecialJoin.find :last, :conditions => ['automated_dynamic_special_id = ? and  tx_time < ?', ads_id, transmission_time], :order => 'tx_time'
  end

  def self.time_difference_last_placing(ads_id, transmission_time)
    if transmission_time.present?
      last = last_placing(ads_id, transmission_time)
      if last
        (transmission_time - last.tx_time)/60  
      else
        1440 #1day
      end
    else
      nil
    end
  end

end
