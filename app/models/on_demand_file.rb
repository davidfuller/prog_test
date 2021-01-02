class OnDemandFile < ActiveRecord::Base

  has_one :on_demand

  default_scope :order => 'uploaded  DESC'

  def display_with_date
    uploaded.localtime.to_s(:broadcast_datetime_no_year) + ' | ' + filename
  end

  def self.display_list
    list = all
    files = []
    files << [['All'],'-1']
    
    list.each do |l|
      files << [[l.display_with_date], l.id.to_s]
    end
    files
  end
end
