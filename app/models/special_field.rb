class SpecialField < ActiveRecord::Base

  default_scope :order => 'dynamic_special_id, number'
  belongs_to :dynamic_special
  
  attr_accessor :source
  
end
