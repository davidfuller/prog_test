class SeriesNumber < ActiveRecord::Base
  
  has_many :houses
  
  default_scope :order => :series_number
    
  validates_uniqueness_of :series_number, :message => " is already in the system"
  
  attr_accessor :source
    
  def self.search(search, page)
    if search
      paginate  :per_page => 12, :page =>page,
                :conditions => ['series_number LIKE ?', "%#{search}%"]
    else
      paginate  :per_page => 12, :page =>page
    end
  end 
  

end
