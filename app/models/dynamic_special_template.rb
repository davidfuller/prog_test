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

  def self.all_with_ads_sports_ipp_select(ads, sports_ipp)
    if ads && sports_ipp
      find(:all, :conditions => ['ads = ? OR sports_ipp = ?', true, true])
    elsif ads
      find(:all, :conditions => ['ads = ?', true], :select =>:name)
    elsif sports_ipp
      find(:all, :conditions => ['sports_ipp = ?', true])
    else
      find(:all)
    end
  end
  
  def self.template_display_with_all(ads, sports_ipp)
    if ads && sports_ipp
      list = find(:all, :conditions => ['ads = ? OR sports_ipp = ?', true, true], :select =>:name).map{|m| m.name}
    elsif ads
      list = find(:all, :conditions => ['ads = ?', true], :select =>:name).map{|m| m.name}
    elsif sports_ipp
      list = find(:all, :conditions => ['sports_ipp = ?', true], :select =>:name).map{|m| m.name}
    else
      list = []
    end
    list.unshift('All')
  end
  

end
