class Aspect < ActiveRecord::Base
  
  has_many :media_folders
  
  default_scope :order => :code
  
end
