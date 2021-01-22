class DynamicSpecialTemplate < ActiveRecord::Base

  has_many :template_field_joins
  has_many :automated_dynamic_specials
  
  default_scope :order =>  'name'

  def next_field_number
    if template_field_joins.count > 0
      current_max = 0
      template_field_joins.each do |field|
        if field.field > current_max
          current_max =field.field
        end
      end
      current_max + 1
    else
      1
    end
  end

  def self.template_display_with_all
    list = find(:all, :select =>:name).map{|m| m.name}
    list.unshift('All')
  end
  

end
