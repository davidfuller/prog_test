class PressLineAutomatedDynamicSpecialJoin < ActiveRecord::Base

  belongs_to :press_line
  belongs_to :automated_dynamic_special
  belongs_to :part

  default_scope :include => :part, :order => "parts.order_number"
end
