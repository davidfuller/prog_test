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

  def self.delete_all_for_a_date_and_channel(date, channel_name, all_week)
    test_date = Date.parse(date)
    if all_week
      start_time = PressLinesController.helpers.monday_this_week_as_time(date) + 6.hour
      end_time = start_time + 7.day
    else
      start_time = test_date + 6.hour
      end_time = start_time + 1.day
    end
    channel = Channel.find_by_name(channel_name)
    count_deleted = 0
    count_not_deleted = 0
    if channel && test_date
      results = PressLineAutomatedDynamicSpecialJoin.find :all, :conditions => ['tx_time >= ? AND tx_time <=? AND press_lines.channel_id = ?', start_time, end_time, channel.id], :joins => :press_line
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
      result.tx_time = my_tx_time[:time]
      if result.save
        count += 1
      end
    end
    count
  end

  def self.find_all_for_actual_part(press_line_id, scheduled_part_id, actual_part_id, last_actual_part_id)
    last_part = Part.last_part
    if scheduled_part_id != last_part.id
    #if scheduled_part is not last part
      if scheduled_part_id == last_actual_part_id
      #if scheduled part is same part as last part
        find :all, :conditions => ['(part_id = ? OR part_id =?) AND press_line_id = ?', scheduled_part_id, last_part.id, press_line_id]
        #find all for scheduled part id and last_part
      else
      #else
        find :all, :conditions => ['part_id = ? AND press_line_id = ?', scheduled_part_id, press_line_id]
        #find all for scheduled part
      end
      #end
    else
    #else
      find :all, :conditions => ['(part_id = ? OR part_id =?) AND press_line_id = ?', scheduled_part_id, actual_part_id, press_line_id]
      # find all for scheduled part and actual part
    end
    #end
  end
end
