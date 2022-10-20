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

  def self.find_all_for_a_date_and_channel(date, channel_name)
    test_date = Date.parse(date)
    channel = Channel.find_by_name(channel_name)
    results = nil
    if channel && test_date
      results = PressLineAutomatedDynamicSpecialJoin.find :all, :conditions => ['DATE(tx_time) = ? AND press_lines.channel_id = ?', test_date, channel.id], :joins => :press_line
    end
    results
  end

  def self.delete_all_for_a_date_and_channel(date, channel_name)
    test_date = Date.parse(date)
    channel = Channel.find_by_name(channel_name)
    logger.debug '-=-=-=-=-=='
    logger.debug test_date
    logger.debug channel.name
    count_deleted = 0
    count_not_deleted = 0
    if channel && test_date
      results = PressLineAutomatedDynamicSpecialJoin.find :all, :conditions => ['DATE(tx_time) = ? AND press_lines.channel_id = ?', test_date, channel.id], :joins => :press_line
      results.each do |result|
        if result.destroy
          count_deleted += 1
        else
          count_not_deleted += 1
        end
      end
    end
    if count_deleted == 0 && count_not_deleted == 0
      message = "Nothing deleted"
    elsif count_deleted == 1 && count_not_deleted == 0
      message = "1 item deleted"
    elsif count_deleted > 1 && count_not_deleted == 0
      message = "#{count_deleted} items deleted"
    elsif count_not_deleted > 0
      message = "#{count_deleted} item(s) deleted and #{count_not_deleted} items(s) not deleted"
    else
      message = "Badd message #{count_deleted} item(s) deleted and #{count_not_deleted} items(s) not deleted"
    end
    message
  end

  def self.fix_missing_tx_time
    results = find :all, :conditions => ['tx_time IS NULL']
    count = 0
    results.each do |result|
      my_tx_time = Part.special_tx_time_from_ids(result.press_line_id, result.part_id)
      result.tx_time = my_tx_time
      if result.save
        count += 1
      end
    end
    count
  end

end
