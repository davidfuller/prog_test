class Status < ActiveRecord::Base
  
  has_many :media_files
  default_scope :order => :value
  
end
