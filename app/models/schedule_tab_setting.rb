class ScheduleTabSetting < ActiveRecord::Base
  
  default_scope :order => 'deletion_rule, position'
  
  
  def self.tab_position(name)
    i = find_by_item(name)
    logger.debug 'name==========>' + name
    logger.debug i
    if i.nil?
      0
      logger.debug 'nil==========>'
      0
    else
      logger.debug i.position
      i.position
    end
  end
  
  def self.delete_tab_info
    deletion_rules = tab_position('DeletionRules')
    start_time = tab_position('Start Time')
    stop_time = tab_position('Stop Time')
    start_date = tab_position('Start Date')
    stop_date = tab_position('Stop Date')
    
    {:deletion_rules => deletion_rules, :start_time => start_time, :stop_time => stop_time,
      :start_date => start_date, :stop_date => stop_date}
  end
  def self.tab_info
     channel = tab_position('Channel')
     date = tab_position('Date')
     time = tab_position('Time')
     programme = tab_position('Programme')
     house_number = tab_position('House Number')
     series_title = tab_position('Series Title')
     title = tab_position('Title')
     series_number = tab_position('Series Number')

     {:channel => channel, :date => date, :time => time, :programme => programme,
       :house_number => house_number, :series_title => series_title, 
       :title => title, :series_number => series_number}
   end
  
end
