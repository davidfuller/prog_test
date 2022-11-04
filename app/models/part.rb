class Part < ActiveRecord::Base

  has_many :press_line_automated_dynamic_special_joins
  default_scope :order => 'order_number'

  attr_accessor :checked

  def self.parts_display
    result = []
    all.each do |part|
      result << [part.name, part.id.to_s]
    end
    result
  end

  def self.selected_part(my_part, force_part_1)
    result = my_part
    if result.nil?||force_part_1
      result = find_by_name("Part 1").id.to_s
    end
    result
  end

  def self.previous(current_id)
    current = find(current_id)
    if current
      result = find :last, :conditions => ['order_number < ?', current.order_number]
      if result.nil?
        result_id = current_id
      else
        result_id =result.id.to_s
      end
    else
      result_id = current_id
    end
    result_id
  end

  def self.next(current_id)
    current = find(current_id)
    if current
      result = find :first, :conditions => ['order_number > ?', current.order_number]
      if result.nil?
        result_id = current_id
      else
        result_id =result.id.to_s
      end
    else
      result_id = current_id
    end
    result_id
  end

  def self.all_with_checked(part_ids)
    parts = all
    if part_ids
      parts.each do |part|
        if part_ids.include? part.id.to_s
          part.checked = true
        else
          part.checked = false
        end
      end
    end
    parts
  end

  def self.special_tx_time_from_ids(press_line_id, part_id)
    tx_time = nil
    press_line = PressLine.find(press_line_id)
    if press_line
      part = find(part_id)
      if part
        tx_time = special_tx_time(press_line, part)
      end
    end
    tx_time #hash
  end

  def self.special_tx_time(press_line, part)

    duration_minutes = press_line.duration_minutes
    special_start_minutes = special_start(duration_minutes, part)

    tx_time = nil
    if special_start_minutes[:start] >= 0
      tx_time = press_line.start + special_start_minutes[:start].minutes
    end
    
    {:time => tx_time, :valid_part => special_start_minutes[:valid_part]}

  end

  def self.special_start(duration_minutes, part)
    num_parts = num_parts(duration_minutes)
    part_duration = part_duration(duration_minutes)
    offset = SpecialScheduleSetting.find_by_name("Offset").value.to_i
    
    start_minutes = -1
    if duration_minutes.to_f >= 4.0
      if part.name == 'Last Part'
        start_minutes = duration_minutes.to_f + (offset/60)
        valid_part = true
      else  
        if part.order_number <= num_parts
          start_minutes = (part.order_number * part_duration) + (offset/60)
          valid_part = true
        else
          start_minutes = duration_minutes - 1
          valid_part = false
        end
      end
    end

    {:start => start_minutes, :valid_part => valid_part}
    
  end

  def self.num_parts(duration_minutes)
    part_breaks = [0, 25, 45, 75, 95, 115]
    num_parts = 0
    if duration_minutes.to_f > 0.0
      part_breaks.each_with_index do |dur, index|
        if index < part_breaks.length - 1
          if duration_minutes.to_f >= part_breaks[index] && duration_minutes.to_f < part_breaks[index+1]
            num_parts = index + 1
            break
          end
        else
          num_parts = part_breaks.length
        end
      end
    end
    num_parts
  end

  def self.part_duration(duration_minutes)
    num_parts = num_parts(duration_minutes)
    if num_parts > 0
      duration_minutes.to_f/num_parts
    else
      0
    end
  end

end
