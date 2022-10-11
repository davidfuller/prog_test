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

end
