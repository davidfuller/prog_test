class TemplateFieldJoin < ActiveRecord::Base

  belongs_to :dynamic_special_template
  belongs_to :dynamic_special_field
  has_many :automated_dynamic_special_fields
  
  default_scope :order =>  'field'

  attr_accessor :source
end
