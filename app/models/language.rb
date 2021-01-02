class Language < ActiveRecord::Base
  
  has_one :channel
  has_many :trailer_house_number_prefixes
  has_many :dynamic_special_logos
  
  validates_presence_of :name, :position
  default_scope :order => :position
  
  def self.display
    all(:select => :name).map{|m| m.name}
  end
  
  
end
