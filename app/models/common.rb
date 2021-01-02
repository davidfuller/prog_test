class Common < ActiveRecord::Base
  
    default_scope :order => :english
    validates_presence_of :english
    validates_uniqueness_of :english
    
    def self.search(search)
      if search
        find(:all, :conditions => ['english LIKE ?', "%#{search}%"])
      else
        find(:all)
      end
    end
  
end
