class ScheduleComparison < ActiveRecord::Base
  
  belongs_to :channel
  
    named_scope :in_db,                                 :conditions => { :comparison_code => 'in_db'}, :order => :start
    named_scope :in_db_no_eidr,                         :conditions => { :comparison_code => 'in_db_no_eidr'}, :order => :start
    named_scope :in_db_local_blank,                     :conditions => { :comparison_code => 'in_db_local_blank'}, :order => :start
    named_scope :in_db_fix_local,                       :conditions => { :comparison_code => 'in_db_fix_local'}, :order => :start
    named_scope :in_db_fix_series,                      :conditions => { :comparison_code => 'in_db_fix_series'}, :order => :start
    named_scope :in_db_house_series_mismatch,           :conditions => { :comparison_code => 'in_db_house_series_mismatch'}, :order => :start
    named_scope :in_db_fix_year,                        :conditions => { :comparison_code => 'in_db_fix_year'}, :order => :start
    named_scope :in_db_fix_english,                     :conditions => { :comparison_code => 'in_db_fix_english'}, :order => :start
    named_scope :in_db_fix_english_year,                :conditions => { :comparison_code => 'in_db_fix_english_year'}, :order => :start
    named_scope :in_db_no_press,                        :conditions => { :comparison_code => 'in_db_no_press'}, :order => :start
    named_scope :in_db_no_press_local_blank,            :conditions => { :comparison_code => 'in_db_no_press_local_blank'}, :order => :start
    named_scope :not_db_all_match,                      :conditions => { :comparison_code => 'not_db_all_match'}, :order => :start
    named_scope :not_db_fix_english,                    :conditions => { :comparison_code => 'not_db_fix_english'}, :order => :start
    named_scope :not_db_fix_local,                      :conditions => { :comparison_code => 'not_db_fix_local'}, :order => :start
    named_scope :not_db_local_blank,                    :conditions => { :comparison_code => 'not_db_local_blank'}, :order => :start
    named_scope :not_db_fix_year,                       :conditions => { :comparison_code => 'not_db_fix_year'}, :order => :start
    named_scope :not_db_fix_english_year,               :conditions => { :comparison_code => 'not_db_fix_english_year'}, :order => :start
    named_scope :not_db_no_series,                      :conditions => { :comparison_code => 'not_db_no_series'}, :order => :start
    named_scope :not_db_no_series_multiple,             :conditions => { :comparison_code => 'not_db_no_series_multiple'}, :order => :start
    named_scope :not_db_no_series_local_blank,          :conditions => { :comparison_code => 'not_db_no_series_local_blank'}, :order => :start
    named_scope :not_db_no_series_local_blank_multiple, :conditions => { :comparison_code => 'not_db_no_series_local_blank_multiple'}, :order => :start
    named_scope :not_db_no_series_fix_local,            :conditions => { :comparison_code => 'not_db_no_series_fix_local'}, :order => :start
    named_scope :not_db_no_series_fix_local_multiple,   :conditions => { :comparison_code => 'not_db_no_series_fix_local_multiple'}, :order => :start
    named_scope :not_db_no_match_contained,             :conditions => { :comparison_code => 'not_db_no_match_contained'}, :order => :start
    named_scope :not_db_no_match,                       :conditions => { :comparison_code => 'not_db_no_match'}, :order => :start
    named_scope :no_press,                              :conditions => { :comparison_code => 'no_press'}, :order => :start
    named_scope :not_found,                             :conditions => ["comparison_code != 'in_db'"], :order => :start   
    named_scope :all,                                   :conditions => {}, :order => :start                                         

   FILTERS = [                                                                                           
     {:scope => "all",                                      :label => "All"},                                   
     {:scope => 'in_db',                                    :label => 'House/Series found. Everything matches'}, 
     {:scope => 'in_db_no_eidr',                            :label => 'House/Series found. No EIDR'}, 
     {:scope => 'in_db_local_blank',                        :label => 'House/Series found. Local title blank'},     
     {:scope => 'in_db_fix_local',                          :label => 'House/Series found. Local title different'}, 
     {:scope => 'in_db_fix_series',                         :label => 'House number linked different series'},  
     {:scope => 'in_db_house_series_mismatch',              :label => 'House number linked to different series/title'},
     {:scope => 'in_db_fix_year',                           :label => 'House/Series found. Year discrepancy'},
     {:scope => 'in_db_fix_english',                        :label => 'House/Series found. Title discrepancy'},
     {:scope => 'in_db_fix_english_year',                   :label => 'House/Series found. Title and year discrepancy'},
     {:scope => 'in_db_no_press',                           :label => 'House found. Not in press listings'},
     {:scope => 'in_db_no_press_local_blank',               :label => 'House found. Not in press listings. Local title blank'},
     {:scope => "not_db_all_match",                         :label => "No House. Series found. Titles match"},
     {:scope => 'not_db_fix_english',                       :label => 'No House. Series found. Title discrepancy'},
     {:scope => 'not_db_fix_local',                         :label => 'No House. Series found. Local title discrepancy'},
     {:scope => 'not_db_local_blank',                       :label => 'No House. Series found. Local title blank'},
     {:scope => 'not_db_fix_year',                          :label => 'No House. Series found. Year discrepancy'},
     {:scope => 'not_db_fix_english_year',                  :label => 'No House. Series found. Title and year discrepancy'},
     {:scope => "not_db_no_series",                         :label => "House/Series not found. Titles match"},
     {:scope => "not_db_no_series_multiple",                :label => "House/Series not found. Multiple titles match"},
     {:scope => "not_db_no_series_local_blank",             :label => "House/Series not found. Title match. Local title blank"},
     {:scope => "not_db_no_series_local_blank_multiple",    :label => "House/Series not found. Multiple title match. Local title blank"},
     {:scope => "not_db_no_series_fix_local",               :label => "House/Series not found. Title match. Local title discrepancy"},
     {:scope => "not_db_no_series_fix_local_multiple",      :label => "House/Series not found. Multiple title match. Local title discrepancy"},
     {:scope => "not_db_no_match_contained",                :label => "Nothing matches, but title is contained in playlist"},
     {:scope => 'not_db_no_match',                          :label => 'Nothing matches'},
     {:scope => 'no_press',                                 :label => 'Not in Press listings'},
     {:scope => "not_found",                                :label => "Not found"}    
   ]
   
  
   def self.filter_display
     filters = []
     FILTERS.each do |filter|
       filters << [[filter[:label]], filter[:scope]]
     end
     filters
   end

   def self.filtered_filter_display(schedule_file_id)
     filters =[]
     filters << ["All","all"]
     filters << ["Not found", "not_found"]
     colours = filtered_colour_display(schedule_file_id)
     colours.each do |c|
       filters << c
     end
     filters
   end

   def self.filtered_colour_display(schedule_file_id)
     filters =[]
     codes = find(:all, :conditions => {:schedule_file_id => schedule_file_id}, :select => 'distinct comparison_code')
     codes.each do |c|
       fil = FILTERS.find { |f| f[:scope] == c.comparison_code }
       if fil
         filters << [fil[:label], fil[:scope]]
       end
     end
     filters
   end

   def code_display
     display = FILTERS.find { |f| f[:scope] == comparison_code }
     display[:label] unless display.nil?
   end
  
  def self.add_prog(schedule, press)
    comp = new
    comp.start = schedule.start
    comp.title = schedule.title
    comp.house_number = schedule.house_no
    comp.series_number = schedule.series_number
    comp.found_house = House.house_exists_and_local_title_not_nil(schedule.house_no, schedule.schedule_file.channel)
    comp.channel = schedule.schedule_file.channel
    comp.found_series = series_exists(schedule.series_number)
    comp.schedule_file_id = schedule.schedule_file_id
    if press.nil?
      comp.original_title = 'Not Found'
      comp.contained = false
      comp.found_title = false
      if House.house_exists(schedule.house_no)
        if House.house_exists_and_local_title_not_nil(schedule.house_no, comp.channel)
          comp.comparison_code = :in_db_no_press.to_s
        else
          comp.comparison_code = :in_db_no_press_local_blank.to_s
        end
      else
        comp.comparison_code = :no_press.to_s
      end
      comp.press_id = 0
    else
      comp.press_start = press.start
      comp.original_title = press.original_title
      comp.local_title = press.display_title
      comp.series_ident = press.series_number
      comp.year = press.year_number
      comp.eidr = press.eidr
      comp.contained = same_title(comp.title, press.original_title)
      comp.found_title = title_exists(press.original_title)
      comp.comparison_code = press.comparison_code(schedule.house_no, comp.contained).to_s
      comp.press_id = press.id
    end
    comp.save
  end
  
  
  def self.update_comparison_code(id, press_id)
    comp = find_by_id(id)
    press = PressLine.find_by_id(press_id)
    
    if comp && press
      comp.comparison_code = press.comparison_code(comp.house_number, comp.contained).to_s
      if comp.series_ident.blank?
        comp.series_ident = press.series_number
      end
      comp.save
    else
      if comp
        if House.house_exists(comp.house_number)
          if House.house_exists_and_local_title_not_nil(comp.house_number, comp.channel)
            comp.comparison_code = :in_db_no_press.to_s
          else
            comp.comparison_code = :in_db_no_press_local_blank.to_s
          end
        else
          comp.comparison_code = :no_press.to_s
        end
        comp.save
      end
    end
  end
  
  def eidr_url
  	if eidr
  		eidr_start = eidr.index("10.5240")
  		if eidr_start
  			clean_eidr = eidr[eidr_start,9999]
  			if clean_eidr
  				"https://ui.eidr.org/view/content?id=" + clean_eidr
  			else
  				nil
  			end
  		else
  			nil
  		end
  	else
  		nil
  	end
  end

  def rounded
    start
  end
  
  
  def row_css
    if self.found_house
      "normal"
    elsif self.found_title && self.contained
      "titled_contained"
    elsif self.found_title
      "titled"
    elsif self.contained
      "contained"
    else
      "missing"
    end
  end
  
  def found?
    self.found_house || self.found_title || self.contained
  end
  
  def original_title_as_param
    if original_title.upcase == "NOT FOUND"
      ""
    else
      original_title
    end
  end
  
  def channel_name
    channel.name||''
  end

  def self.sport_programme_options
    ["All", "Sport only", "Non sport only"]
  end
  
  private
  
  def self.same_title(schedule_title, press_title)
  	if schedule_title && press_title
			contained = schedule_title.upcase.include? press_title.upcase
			if !contained
				test = press_title.upcase
				Ignore.all.each do |w|
					test = test.gsub(w.word.upcase,'').squeeze(" ").strip
					if schedule_title.upcase.include? test
						contained = true
					end
				end
			end
		end
    contained
  end
  
  def self.series_exists(series_number)
		s = SeriesNumber.find_by_series_number(series_number)
  	!s.nil?
  end
  
  def self.title_exists(title)
    t=Title.find_by_english(title)
    !t.nil?
  end
  
end
