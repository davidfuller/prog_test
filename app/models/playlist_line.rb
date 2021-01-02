class PlaylistLine < ActiveRecord::Base
  
  belongs_to :playlist_filename
  
  named_scope :all_progs,       :conditions => 'material_type == "" AND part > 0' 
  named_scope :progs_part1,     :conditions => { :material_type => "", :part => 1}
  named_scope :full_progs,      :conditions => { :material_type => "", :full_programme => true}
  named_scope :full_progs_part1,      :conditions => { :material_type => "", :part => 1, :full_programme => true}
  
  FILTERS = [
    {:scope => "all",               :label => "All",                        :position => 0},
    {:scope => "all_progs",         :label => "Programmes Only",            :position => 1},
    {:scope => "progs_part1",       :label => "Part 1 of Programmes",       :position => 2},
    {:scope => "full_progs",        :label => "Full Programmes",            :position => 3},
    {:scope => "full_progs_part1",  :label => "Part 1 of Full Programmes",  :position => 4}    
  ]
  
  def self.filter_display
    filters = []
    FILTERS.each do |filter|
      filters << [filter[:label],filter[:scope]]
    end
    filters
  end
  
  def self.search_by_filename_id(params, selected_file)
    
    case params[:show]
    when 'all_progs'
      result = all_progs.find_all_by_playlist_filename_id(selected_file)
    when 'progs_part1'
      result = progs_part1.find_all_by_playlist_filename_id(selected_file)
    when 'full_progs'
      result = full_progs.find_all_by_playlist_filename_id(selected_file)
    when 'full_progs_part1'
      result = full_progs_part1.find_all_by_playlist_filename_id(selected_file)
    when 'all'
      result = find_all_by_playlist_filename_id(selected_file)
    else
      result = full_progs_part1.find_all_by_playlist_filename_id(selected_file)
    end
  
    result.paginate   :per_page => 15, :page =>params[:page]
  end
      
  def addline(line, pos, part_number, last_material, date_offset, filename)
    @line = line
    @pos = pos
    @prog_part = part_number
    @last_material = last_material
    @date_offset = date_offset
    @type = get_field(:type)
    @material = get_field(:material_id)
    
    start_date = get_field(:start_date)
    start_time = get_field(:start_time)
    original = start_date_time(start_date,start_time)
    duration = get_field(:duration)
    
    playlist = PlaylistLine.new
    playlist.event = get_field(:event)
    playlist.title = get_field(:title)
    playlist.start = original
    playlist.rounded = rounded_date_time(original)
    playlist.duration = duration_time(duration)
    playlist.source = get_field(:source)
    playlist.material_type = @type
    playlist.house_no = @material
    playlist.part = calc_part
    playlist.long_title = get_field(:long_title)
    tc = timecode_time(get_field(:timecode))
    playlist.timecode = tc
    playlist.full_programme = full_prog(tc)
    playlist.playlist_filename = filename
    playlist.save
  end
  
  def part_no
    if prog?
      calc_part
    else
      @prog_part
    end
  end
  
  def date_offset
    @date_offset
  end
  
  def house_number
    prog? ? @material : @last_material
  end
  
  def calc_part
    if prog?
      (@material == @last_material) ? @prog_part + 1 : 1
    else
      0
    end
  end
     
  def prog?
    @type.strip.empty? and !@material.strip.empty?
  end
  
  def self.get_channel(file, pos)
    @pos = pos
    found = false
    while (@line=file.gets) && (!found)
      source = get_field(:source).strip
      if source && !(source.empty?)
        channel = Channel.find_by_playlist_code(source)
        if channel
          found=true
        end
      end
    end
    channel
  end
  
  private 
  
  def start_date_time (start_date, start_time)
    # Expects start_date to be a string in the format ddmmyy
    # Expects start_time to be a string in the format hh:mm:ss:ff

    t = DateTime.strptime(start_date+start_time,"%d%m%y%H:%M:%S") 
    if (@date_offset == 0) and (t.hour == 0)
      @date_offset = 1
    end
     
    t = t + @date_offset.days
    
  rescue ArgumentError
    nil
  end
  
  def timecode_time(tc)
    # Expects tc to be a string in the format hh:mm:ss:ff
    DateTime.strptime(tc, "%H:%M:%S")
  rescue ArgumentError
    nil
  end
  
  def duration_time (duration)
    # Expects duration to be a string in the format h:mm:ss:ff
    DateTime.strptime('0'+duration, "%H:%M:%S")
  rescue ArgumentError
    nil
  end
  
  def rounded_date_time (odt)
    # expects a datetime
    if odt.nil?
      nil
    else
      odt = odt + 1.minutes
      DateTime.new(odt.year,odt.month,odt.day,odt.hour,((odt.min)/5)*5,0)
    end
    
    rescue ArgumentError
       nil
  end
  
  def get_field(name)
    @line[@pos[name].position-1, @pos[name].length].strip
  end
  
  def self.get_field(name)
    @line[@pos[name].position-1, @pos[name].length].strip
  end
  
  def full_prog(tc)
    if tc.nil?
      nil
    else
      (tc.hour != 5) or (tc.min != 0) or (tc.sec != 0)
    end
  rescue ArgumentError
       nil
  end    

  
    

end
