class House < ActiveRecord::Base
  belongs_to :title
  belongs_to :series_number
  belongs_to :series_ident
  
  default_scope :order => :house_number
    
  validates_uniqueness_of :house_number, :message => " is already in the system"
  validates_presence_of :series_ident_id
  
  attr_accessor :source
  attr_accessor :schedule_comparison_id
  attr_accessor :press_id
  attr_accessor :comparison_id
  
  def self.search(search, page)
    if search
      paginate  :per_page => 16, :page =>page,
                :conditions => ['house_number LIKE ?', "%#{search}%"]
    else
      paginate  :per_page => 16, :page =>page
    end
  end 

  def title_with_details
    t=[]
    if series_ident
      t= series_ident.title_with_details
    end
  end
  
  def english_title
    if series_ident && series_ident.title && series_ident.title.english
      series_ident.title.english
    else
      ""
    end
  end
        
  def self.add_from_comparison(comparison_id, comparison_type)
  	logger.debug '<AAAA>'
    if comparison_type == 'schedule_comparison'
      c = ScheduleComparison.find_by_id(comparison_id)
    else
      c = Comparison.find_by_id(comparison_id)
    end
    added = 0
    issues = 0
    success = false
    promo_added = 0
    notice = ''
    s = SeriesIdent.find_by_eidr(c.eidr)
    if s.nil?
    	if !c.series_ident.blank?
    		s = SeriesIdent.find_by_number(c.series_ident)
			end
    	if s.nil?
				#We cannot find the series either by EIDR or series_ident
				# if house record contains the same title and year data, then we just need to add eidr
				
				h = find_by_house_number(c.house_number)
				logger.debug '<1KKKKK>'
				logger.debug h.series_ident.title.english 
				if h && h.series_ident && h.series_ident.title
					logger.debug '<2KKKKK>'
					logger.debug h.series_ident.title.english 
					logger.debug c.original_title
					logger.debug h.series_ident.year_number
					logger.debug c.year
					if h.series_ident.year_number == c.year
						s = h.series_ident
						s.eidr = c.eidr
						if s.save
							notice += 'Series Ident/EIDR updated'
						end
						h.save
					else
						s = SeriesIdent.new
						if c.series_ident.blank?||c.series_ident="0"
							s.number = SeriesIdent.new_dummy
						else 
							s.number = c.series_ident
						end
						s.year_number = c.year
						s.eidr = c.eidr
						s.title = h.series_ident.title
						if s.save
							notice += 'Series Ident created. '
							promo_added += s.add_missing_promos(s.title.id)
						else
							s.errors.each_full do |err|
								issues += 1
								notice += err + ". "
							end
							s = nil
						end
					end
				else
					notice += 'House number not found. '
				end
			else
				#We didn't find it by EIDR but we did by series_ident
				s.eidr = c.eidr
				s.save
				h = find_or_create_by_house_number(c.house_number)
				h.series_ident = s
				h.house_number = c.house_number
				if h.save
					added += 1
					success = true
				else
					h.errors.each_full do |err|
						if err.upcase != "HOUSE NUMBER  IS ALREADY IN THE SYSTEM"
							logger.debug "============>" + err.upcase
							issues += 1
							notice += err + ". "
						end
					end
				end
			end
		else
			#We found it by eidr
			logger.debug "Hello Johnny"
			h = find_or_create_by_house_number(c.house_number)
			h.series_ident = s
			h.house_number = c.house_number
			h.title = s.title
			if h.save
				added += 1
				success = true
			else
				h.errors.each_full do |err|
					if err.upcase != "HOUSE NUMBER  IS ALREADY IN THE SYSTEM"
						logger.debug "============>" + err.upcase
						issues += 1
						notice += err + ". "
					end
				end
			end
    end
    {:added => added, :issues => issues, :notice => notice, :success => success, :promo_added => promo_added}
  end
  
  def self.house_exists_and_local_title_not_nil(house_number, channel)
    h = find_by_house_number(house_number)
    if h
      if h.series_ident
        case channel.language.name
        when 'Danish'
          t = h.series_ident.title.danish
        when 'Swedish'
          t = h.series_ident.title.swedish
        when 'Hungarian'
          t = h.series_ident.title.hungarian
        when 'Norwegian'
          t = h.series_ident.title.norwegian
        end
        !t.nil? && !t.empty?
      else
        !h.series_ident.nil?
      end
    else
      !h.nil?
    end
  end
  
  def self.house_exists(house_number)
    h = find_by_house_number(house_number)
    !h.nil?
  end
  
  def self.add_eidr_to_existing_house(comparison_id, comparison_type)
  
		if comparison_type == 'schedule_comparison'
      c = ScheduleComparison.find_by_id(comparison_id)
    else
      c = Comparison.find_by_id(comparison_id)
    end
    
    added = 0
    issues = 0
    success = false
    notice = ''

	  h = find_by_house_number(c.house_number)
		if h && h.series_ident 
			logger.debug 'MON<3KKKKK>'
			logger.debug c.eidr
			h.series_ident.eidr = c.eidr
			h.series_ident.save
			if h.save
				notice += 'House number updated. '
				added += 1
				success = true
				logger.debug h.series_ident.eidr
			else
				h.errors.each_full do |err|
					logger.debug '<4KKKKK>'
					if err.upcase != "HOUSE NUMBER  IS ALREADY IN THE SYSTEM"
						logger.debug "============>" + err.upcase
						issues += 1
						notice += err + ". "
					end
				end
			end
		else
			notice += 'House number not found. '
		end
		 {:added => added, :issues => issues, :notice => notice, :success => success}
  end
  


  
end
