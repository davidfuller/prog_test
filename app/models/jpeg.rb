class Jpeg < ActiveRecord::Base
  
  belongs_to :jpeg_folder
  
  #named_scope :previous, lambda{|p| {:conditions => ["id < ? AND jpeg_folder_id = ?", p.id, p.jpeg_folder_id], :limit => 1 , :order => "id DESC"}}
  #named_scope :nextj, lambda{|p| {:conditions => ["id > ? AND jpeg_folder_id = ?", p.id, p.jpeg_folder_id], :limit => 1 , :order => "id"}}
  named_scope :previous, lambda{|p, search| {:conditions => ["name < ? AND jpeg_folder_id = ? and name LIKE ?", p.name, p.jpeg_folder_id, "%#{search}%"], :limit => 1 , :order => "name DESC"}}
  named_scope :nextj, lambda{|p, search| {:conditions => ["name > ? AND jpeg_folder_id = ? AND name LIKE ?", p.name, p.jpeg_folder_id, "%#{search}%" ],:limit => 1 ,:order => "name"}}
  
  def self.search(folder, search, page)
    if folder.nil?
      folder = JpegFolder.first
    end
    
    JpegFolder.scan_folder(folder)
    paginate  :per_page => 9, :page =>page,
              :conditions => ['jpeg_folder_id = ? and name LIKE ?', folder, "%#{search}%"],
              :order => 'name'
  end
  
  def self.none_by_name_and_folder_id(name,folder_id)
    jpegs = find(:all, :conditions => ["name = ? and jpeg_folder_id =?", name, folder_id])
    jpegs[0].nil?
  end
  
  def self.delete_by_name_and_folder_id(name, folder_id)
    destroy_all(["name = ? and jpeg_folder_id =?", name, folder_id])
  end
     
  def image_url
    if jpeg_folder.full_path
      jpeg_folder.full_path + filename 
    end   
  end
  
  def self.previous_jpeg(j, search)
    p = previous(j, search)
    if p[0].nil?
      j
    elsif p[0].jpeg_folder.nil?
      j
    elsif p[0].jpeg_folder != j.jpeg_folder
      j
    else
      p
    end
  end
    
  def self.next_jpeg(j, search)
    p = nextj(j, search)
    if p[0].nil?
      j
    elsif p[0].jpeg_folder.nil?
      j
    elsif p[0].jpeg_folder != j.jpeg_folder
      j
    else
      p
    end
  end
  
  def jpeg_size 
    "712x400"
  end
  
  def thumbnail_size
    "160x90"
  end
  
  def four_by_three?
    filename[3,1] == "S"
  end
  
end
