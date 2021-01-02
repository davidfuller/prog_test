class DivaLog < ActiveRecord::Base

  belongs_to :trailer
  belongs_to :diva_status
  default_scope :order => 'updated_at DESC'

  def self.search(search, page)
    if search 
      paginate  :per_page => 30, :page => page,
                :joins => :trailer, :conditions => ['house_number LIKE ?', "%#{search}%"]
    else
      paginate  :all, :per_page => 30, :page => page
    end
  end 

end
