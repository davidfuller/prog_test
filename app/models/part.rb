class Part < ActiveRecord::Base

  has_many :press_line_automated_dynamic_special_joins
  default_scope :order => 'order_number'

  def self.parts_display
    result = []
    all.each do |part|
      result << [part.name, part.id.to_s]
    end
    result
  end
end
