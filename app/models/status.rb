class Status < ActiveRecord::Base
  
  has_many :media_files
  default_scope :order => :value

  def self.search(params)
    if params[:message]
      find_all_by_message(params[:message])
    else
      all
    end
  end

end
