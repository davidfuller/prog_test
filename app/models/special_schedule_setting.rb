class SpecialScheduleSetting < ActiveRecord::Base

def self.scheduling_priorities
  search = 'Priority'
  priorities = find :all, :conditions => ['name like ?', "%#{search}%"], :order => :name
  result = []
  priorities.each do |priority|
    my_index = priority.name.tr("^0-9","").to_i
    result[my_index] = priority.value.to_i
  end
  result
end

def self.priority_options
  search = 'Priority'
  priorities = find :all, :conditions => ['name like ?', "%#{search}%"], :order => :name
  result = {}
  priorities.each do |priority|
    my_index = priority.name.tr("^0-9","")
    result[priority.name] = my_index 
  end
  result.sort
  
end

def self.schedule_filters
  results = []
  filters = find_all_by_name("Schedule Filter")
  filters.each do |filter|
    items = filter.value.split(",")
    if items.length == 4
      my_filter = {:order => items[0].to_i, :label => items[1], :start => items[2], :end => items[3]}
      results << my_filter
    end
  end
  results
end

def self.schedule_filter_labels
  result = []
  filters = schedule_filters
  filters.each do |filter|
    result << filter[:label]
  end
  result
end

def self.times_for_label(label)
  filters = schedule_filters
  filters.each do |filter|
    if filter[:label] == label
      result = {:start => filter[:start], :end => filter[:end]}
      return result
    end
  end
  filters.each do |filter|
    if filter[:label] == 'All'
      result = {:start => filter[:start], :end => filter[:end]}
      return result
    end
  end
end

def self.default_schedule_filter
  find_by_name("Default Schedule Filter").value
end

def self.part_random_start_time
  find_by_name("Part Random Start Time").value
end

def self.part_random_end_time
  find_by_name("Part Random End Time").value
end

def self.default_random_gap
  find_by_name("Random Gap").value
end
 
end
