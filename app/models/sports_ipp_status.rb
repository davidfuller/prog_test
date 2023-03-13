class SportsIppStatus < ActiveRecord::Base
  
  has_many :sports_ipp_medias
  default_scope :order =>  'position'
  
end
