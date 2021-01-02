class TrailerHouseNumberPrefix < ActiveRecord::Base

  belongs_to :language

  default_scope :order => :prefix

end
