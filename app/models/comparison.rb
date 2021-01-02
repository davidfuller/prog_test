class Comparison < ActiveRecord::Base
  
    belongs_to :channel                       
    
    named_scope :in_db,                                 :conditions => { :comparison_code => 'in_db'}, :order => :rounded
    named_scope :in_db_local_blank,                     :conditions => { :comparison_code => 'in_db_local_blank'}, :order => :rounded
    named_scope :in_db_fix_local,                       :conditions => { :comparison_code => 'in_db_fix_local'}, :order => :rounded
    named_scope :in_db_fix_series,                      :conditions => { :comparison_code => 'in_db_fix_series'}, :order => :rounded
    named_scope :in_db_fix_year,                        :conditions => { :comparison_code => 'in_db_fix_year'}, :order => :rounded
    named_scope :in_db_fix_english,                     :conditions => { :comparison_code => 'in_db_fix_english'}, :order => :rounded
    named_scope :in_db_fix_english_year,                :conditions => { :comparison_code => 'in_db_fix_english_year'}, :order => :rounded
    named_scope :in_db_no_press,                        :conditions => { :comparison_code => 'in_db_no_press'}, :order => :rounded
    named_scope :in_db_no_press_local_blank,            :conditions => { :comparison_code => 'in_db_no_press_local_blank'}, :order => :rounded
    named_scope :not_db_all_match,                      :conditions => { :comparison_code => 'not_db_all_match'}, :order => :rounded
    named_scope :not_db_fix_english,                    :conditions => { :comparison_code => 'not_db_fix_english'}, :order => :rounded
    named_scope :not_db_fix_local,                      :conditions => { :comparison_code => 'not_db_fix_local'}, :order => :rounded
    named_scope :not_db_local_blank,                    :conditions => { :comparison_code => 'not_db_local_blank'}, :order => :rounded
    named_scope :not_db_fix_year,                       :conditions => { :comparison_code => 'not_db_fix_year'}, :order => :rounded
    named_scope :not_db_fix_english_year,               :conditions => { :comparison_code => 'not_db_fix_english_year'}, :order => :rounded
    named_scope :not_db_no_series,                      :conditions => { :comparison_code => 'not_db_no_series'}, :order => :rounded
    named_scope :not_db_no_series_multiple,             :conditions => { :comparison_code => 'not_db_no_series_multiple'}, :order => :rounded
    named_scope :not_db_no_series_local_blank,          :conditions => { :comparison_code => 'not_db_no_series_local_blank'}, :order => :rounded
    named_scope :not_db_no_series_local_blank_multiple, :conditions => { :comparison_code => 'not_db_no_series_local_blank_multiple'}, :order => :rounded
    named_scope :not_db_no_series_fix_local,            :conditions => { :comparison_code => 'not_db_no_series_fix_local'}, :order => :rounded
    named_scope :not_db_no_series_fix_local_multiple,   :conditions => { :comparison_code => 'not_db_no_series_fix_local_multiple'}, :order => :rounded
    named_scope :not_db_no_match_contained,             :conditions => { :comparison_code => 'not_db_no_match_contained'}, :order => :rounded
    named_scope :not_db_no_match,                       :conditions => { :comparison_code => 'not_db_no_match'}, :order => :rounded
    named_scope :no_press,                              :conditions => { :comparison_code => 'no_press'}, :order => :rounded
    named_scope :not_found,                             :conditions => ["comparison_code != 'in_db'"], :order => :rounded                                            

   FILTERS = [                                                                                           
     {:scope => "all",                                      :label => "All"},                                   
     {:scope => 'in_db',                                    :label => 'House/Series found. Everything matches'},     
     {:scope => 'in_db_local_blank',                        :label => 'House/Series found. Local title blank'},     
     {:scope => 'in_db_fix_local',                          :label => 'House/Series found. Local title different'}, 
     {:scope => 'in_db_fix_series',                         :label => 'House number linked different series'},  
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
   
   def self.filtered_filter_display
     filters =[]
     filters << ["All","all"]
     filters << ["Not found", "not_found"]
     colours = filtered_colour_display
     colours.each do |c|
       filters << c
     end
     filters
   end
   
   def self.filtered_colour_display
     filters =[]
     codes = find(:all, :select => 'distinct comparison_code')
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

  def self.add_prog(playlist, press)
    comp = Comparison.new
    comp.start = playlist.start
    comp.rounded = playlist.rounded
    comp.long_title = playlist.long_title
    comp.house_no = playlist.house_no
    channel = playlist.playlist_filename.channel
    comp.found_house = House.house_exists_and_local_title_not_nil(playlist.house_no, channel)
    comp.channel = playlist.playlist_filename.channel
    if press.nil?
      comp.original_title = 'Not Found'
      comp.contained = false
      comp.found_title = false
      if House.house_exists(playlist.house_no)
        if House.house_exists_and_local_title_not_nil(playlist.house_no,channel)
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
      comp.danish_title = press.display_title
      comp.series_ident = press.series_number
      comp.year = press.year_number
      comp.contained = same_title(comp.long_title, press.original_title)
      comp.found_title = title_exists(press.original_title)
      comp.comparison_code = press.comparison_code(playlist.house_no, comp.contained).to_s
      comp.press_id = press.id
    end
    comp.save
  end
  
  def row_css
    if self.found_house
      "normal"
    elsif self.found_title
      "titled"
    elsif self.contained
      "contained"
    else
      "missing"
    end
  end
  
  def original_title_as_param
    if original_title.upcase == "NOT FOUND"
      ""
    else
      original_title
    end
  end
  
  def found?
    self.found_house || self.found_title || self.contained
  end
  
  def channel_name
    channel.name||''
  end
  
  def local_title
    danish_title
  end
  
  def house_number
    house_no
  end
  
  def title
    long_title
  end
  
  private
  
  def self.same_title(playlist_title, press_title)
    contained = playlist_title.upcase.include? press_title.upcase
    if !contained
      test = press_title.upcase
      Ignore.all.each do |w|
        test = test.gsub(w.word.upcase,'').squeeze(" ").strip
        if playlist_title.upcase.include? test
          contained = true
        end
      end
    end
    contained
  end
  
  def self.title_exists(title)
    t=Title.find_by_english(title)
    !t.nil?
  end
  
  def self.local_title_exits(title, channel)

    case channel.language.name
    when 'Danish'
      t = Title.find_by_danish(title)
    when 'Swedish'
      t = Title.find_by_swedish(title)
    when 'Hungarian'
      t = Title.find_by_hungarian(title)
    when 'Norwegian'
      t = Title.find_by_norwegian(title)
    end
    !t.nil? && !t.empty?
    
  end
end
