class Promo < ActiveRecord::Base
    
    has_and_belongs_to_many :media_files
    has_and_belongs_to_many :series_idents
    belongs_to :title
    has_many :on_demands
    
    default_scope :order => :name

    validates_uniqueness_of :name, :message => " is already in the system"
    validates_presence_of :name

  def self.past_last_use(params)

    if params[:media_type_display].nil? || params[:media_type_display] == 'All'
      media_type_id = nil
    else
      media_type_id = MediaType.find_by_name(params[:media_type_display]).id
    end

    if Useful.date?(params[:last_use_date])
      last_use_date = Date.parse(params[:last_use_date]).strftime('%F')
      
      if params[:search]
        if media_type_id
          paginate  :per_page => 12, :page =>params[:page],
                    :joins => :media_files, 
                    :conditions => ['promos.name LIKE ? and DATE(promos.last_use) <= ? and media_files.media_type_id = ?', "%#{params[:search]}%", last_use_date, media_type_id]
        else
          paginate  :per_page => 12, :page =>params[:page],
                    :joins => :media_files, 
                    :conditions => ['promos.name LIKE ? and DATE(promos.last_use) <= ?', "%#{params[:search]}%", last_use_date]
        end
      else
        if media_type_id
          paginate  :per_page => 12, :page =>params[:page],
                    :joins => :media_files, 
                    :conditions => ['DATE(promos.last_use) <= ? and media_files.media_type_id = ?', last_use_date, media_type_id]
        else
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['DATE(last_use) <= ?', last_use_date]
        end
      end
    else
      if params[:search]
        if media_type_id
          paginate  :per_page => 12, :page =>params[:page],
                    :joins => :media_files, 
                    :conditions => ['promos.name LIKE ? and media_files.media_type_id = ?', "%#{params[:search]}%", media_type_id]
        else
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['name LIKE ?', "%#{params[:search]}%"]
        end
      else
        if media_type_id
          paginate  :per_page => 12, :page =>params[:page],
                    :joins => :media_files, 
                    :conditions => ['media_files.media_type_id = ?', media_type_id]
        else
          paginate  :all, :per_page => 12, :page =>params[:page]
        end
      end
    end
  end

  def self.search(search, page)
    if search
      paginate  :per_page => 12, :page => page,
                :conditions => ['name LIKE ?', "%#{search}%"]
    else
      paginate  :all, :per_page => 12, :page =>page
    end
  end 

  def self.search_portrait(search, page)
    if search
      paginate  :per_page => 12, :page =>page,
                :joins => :media_files, :conditions => ['promos.name LIKE ? and media_files.media_type_id = ?', "%#{search}%", 4]
    else
      paginate  :all, :per_page => 12, :page => page,
                :joins => :media_files, :conditions  => ['media_files.media_type_id = ?',  4]
    end
  end


  def self.new_with_default_times
    p = Promo.new
    p.first_use = Date.today.to_datetime.advance(:days => 7, :hours => 5)
    p.last_use = p.first_use.advance(:months => 6)
    p
  end    
  
  def self.filter_expired(params)
    last_use_date = Date.parse(params[:last_use]).strftime('%F')
    find(:all, :conditions => ['DATE(last_use) >= ? ' , last_use_date])
  end

  def self.filter_expired_updated_after(params)
    if params[:last_use] && params[:updated_after]
      last_use_date = Date.parse(params[:last_use]).strftime('%F')
      updated_after_date = Date.parse(params[:updated_after]).strftime('%F')
#      find(:all, :conditions => ['DATE(last_use) >= ? AND DATE(updated_at) >= ?', last_use_date, updated_after_date])
      if params[:portrait]
        find(:all, :select=> "DISTINCT(promos.id), promos.*", :joins => :media_files, :conditions => ['DATE(promos.last_use) >= ? AND (DATE(promos.updated_at) >= ? OR DATE(media_files.updated_at) >= ?) AND media_type_id=4', last_use_date, updated_after_date, updated_after_date])
      else
        find(:all, :select=> "DISTINCT(promos.id), promos.*", :joins => :media_files, :conditions => ['DATE(promos.last_use) >= ? AND (DATE(promos.updated_at) >= ? OR DATE(media_files.updated_at) >= ?)', last_use_date, updated_after_date, updated_after_date])
      end
    elsif params[:last_use]
      last_use_date = Date.parse(params[:last_use]).strftime('%F')
      if params[:portrait]
        find(:all, :select=> "DISTINCT(promos.id), promos.*", :joins => :media_files, :conditions => ['DATE(promos.last_use) >= ? AND media_type_id=4', last_use_date])
      else
        find(:all, :conditions => ['DATE(last_use) >= ? ' , last_use_date])
      end
    elsif params[:updated_after]
      updated_after_date = Date.parse(params[:updated_after]).strftime('%F')
#      find(:all, :conditions => ['DATE(updated_at) >= ?', updated_after_date])
      if params[:portrait]
        find(:all, :select=> "DISTINCT(promos.id), promos.*", :joins => :media_files, :conditions => ['(DATE(promos.updated_at) >= ? OR DATE(media_files.updated_at) >= ?) AND media_type_id=4', updated_after_date, updated_after_date])
      else
        find(:all, :select=> "DISTINCT(promos.id), promos.*", :joins => :media_files, :conditions => ['DATE(promos.updated_at) >= ? OR DATE(media_files.updated_at) >= ?', updated_after_date, updated_after_date])
      end  
    else
      :all
    end
  end

  def add_file(media_file)
    media_files << media_file
  end
  
  def self.change_last_use_and_media(id, new_last_use)
    p = find(id)
    p.last_use = new_last_use
    num_added = 0
    if p.save
      p.media_files.each do |media|
        m = MediaFile.find(media.id)
        m.last_use = new_last_use
        m.save
        num_added += 1
      end
      num_added
    else
      nil
    end
  end
  
  def create_series_ident
    num = 0
    if series_idents.count == 0
      if title && title.series_idents
        title.series_idents.each do |s|
          series_idents << s
          num += 1
        end
      end
    end
    num
  end
  
  def add_series_ident(series_ident_id)
    if series_ident_id
      s = SeriesIdent.find(series_ident_id)
      if s then    
        if series_idents.detect {|element| element == s}  
          'Already exits'
        else
          series_idents << s
          'Added'
        end
      end
    end
  end
  
  def remove_series_ident(series_ident_id)
    
    if series_ident_id
      s = SeriesIdent.find_by_id(series_ident_id)
      if s then    
        d = series_idents.detect {|element| element == s}
        if d
          series_idents.delete(d)
          'Series ident removed'
        else
          'Series ident could not be removed'
        end
      else
        'Series ident could not be removed'
      end
    else
      'Series ident could not be removed'
    end
    
  end
      
  def first_english_title
    if series_idents
      series_ident = series_idents[0]
      if series_ident && series_ident.title && series_ident.title.english
        series_ident.title.english
      else
        ""
      end
    end
  end

  def portrait_media_files
    MediaFile.find(:all, :joins => :promos, :conditions  => ['promos.id = ? AND media_type_id = ?', self.id, 4])
  end

  def total_count
    series_idents.count + on_demands.count
  end


protected

end
