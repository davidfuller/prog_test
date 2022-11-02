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


end
