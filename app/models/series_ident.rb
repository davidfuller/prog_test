class SeriesIdent < ActiveRecord::Base

  belongs_to :title
  has_many :houses, :autosave => :true
  has_and_belongs_to_many :promos
  
  default_scope :order => :number
    
  validates_uniqueness_of :number, :message => " is already in the system"
  validates_presence_of :title_id
  
  attr_accessor :source
  attr_accessor :schedule_comparison
  attr_accessor :original_id
  attr_accessor :original_channel
  attr_accessor :schedule_comparison_id
  attr_accessor :press_id
  
  def self.search(params)
    if params[:search]
      paginate  :per_page => 16, :page => params[:page],
                :conditions => ['number LIKE ? OR eidr LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%"]
    else
      paginate  :per_page => 16, :page => params[:page]
    end
  end
  
  def self.new_dummy
    current_last = last(:conditions => ['number like ?', "D%"])
    if current_last
      "D"+ "%07d" % (current_last.number[1..99].to_i+1)
    else
      "D"+ "%07d" % 1
    end 
  end
  
  def self.create_new_dummy(title_id)
    s = new
    s.number = self.new_dummy
    s.description = 'Legacy'
    s.title_id = title_id
    s.save
  end
  
  def new_dummy_number
    current_last = SeriesIdent.last(:conditions => ['number like ?', "D%"])
    if current_last
      "D"+ "%07d" % (current_last.number[1..99].to_i+1)
    else
      "D"+ "%07d" % 1
    end 
  end
  
  def update_info(title_id, press_id)
      p = PressLine.find(press_id)
      if p.series_number.blank?
      	self.number = new_dummy_number
      else	
	      self.number = p.series_number
	    end
	    
	    logger.debug self.number
      self.year_number = p.year_number
      self.eidr = p.eidr
      self.title_id = title_id
  end
  
  def add_eidr(press_id)
  	p = PressLine.find(press_id)
    self.eidr = p.eidr
  end
   
  def reset_legacy
    if self.description == 'Legacy'
      self.description=''
    end
  end    
  
  def full_description
    d = ""
    if number then
      d = number.to_s
      if !year_number.blank? then
        d += ' - Year: ' + year_number
      else
        d
      end
      if !description.blank? then
        d += ' - ' + description
      else
        d
      end
    else
      d
    end
  end

  def full_description_with_eidr
    full_description + ' ' + eidr
  end
  
  def title_with_details
    t=[]
    if title
    	if title.english
        t << {:description => 'Title', :value => title.english}
        t << {:description => 'Description', :value => title.description} unless title.description.blank?
        t << {:description => 'Series Ident', :value => full_description} unless full_description.blank?
        t << {:description => 'EIDR', :value => eidr, :url => eidr_url} unless eidr.blank?
        t
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
  
  def remove_promo(promo_id)  
    if promo_id
      p = Promo.find_by_id(promo_id)
      if p then    
        d = promos.detect {|element| element == p}
        if d
          promos.delete(d)
          'Promo removed'
        else
          'Promo could not be removed1'
        end
      else
        'Promo could not be removed2'
      end
    else
      'Promo could not be removed3'
    end
  end
  
  def add_missing_promos(title_id)
    t = Title.find_by_id(title_id)
    promo_added = 0
    if t
      t.series_idents.each do |si|
        if self != si
        	if si.year_number == self.year_number
						promos = si.promos
						current = self.promos
						promos.each do |p|
							if !current.detect {|element| element == p }
								self.promos << p 
								promo_added += 1
							end
						end
					end
        end
      end
      promo_added
    else
      0
    end
  end
  
  
  
end
