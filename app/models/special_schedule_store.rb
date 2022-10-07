class SpecialScheduleStore < ActiveRecord::Base

  def self.store_ads_join(press_filename_id)  
  
    destroy_all(['press_filename_id = ?', press_filename_id])
    press = PressLine.find_all_by_press_filename_id(press_filename_id)
    if press
      press.each do |line|
        the_joins = line.press_line_automated_dynamic_special_joins
        if the_joins.length > 0
          the_joins.each do |join|
            s = SpecialScheduleStore.new
            s.press_filename_id = press_filename_id
            s.start = line.start
            s.join_id = join.id
            s.save
          end
        end
     end
    end
  end   
  
  def self.add_press_line_ids_to_joins(start, press_filename_id, press_line_id)
    
    result = []
    the_joins = find_all_by_press_filename_id_and_start(press_filename_id, start)
    if the_joins.length > 0  
      the_joins.each do |join|
        join_item = PressLineAutomatedDynamicSpecialJoin.find(join.join_id)
        join_item.press_line_id = press_line_id
        join_item.save
        result << join_item
      end
    end
    result
  end


end


