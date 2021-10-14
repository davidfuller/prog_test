class DynamicSpecialMedia < ActiveRecord::Base
  belongs_to :media_file, :dependent => :destroy
  belongs_to :dynamic_special_image_spec

  #default_scope :joins => :media_file, :order => 'media_files.name'

  PER_PAGE = 5


  def self.search(params)
    page = params[:page]
    search = params[:search]
    image_type = params[:image_type]
    created_sort = params[:created_sort].present?

    if created_sort
      sort_text = 'created_at DESC'
    else
      sort_text = 'media_files.name'
    end
    if !image_type || image_type == 'All'
      paginate  :all, :per_page => PER_PAGE, :page => page, :joins => :media_file,
                :conditions => ['media_files.name LIKE ?', "%#{search}%"],
                :order => sort_text
    else
      paginate  :all, :per_page => PER_PAGE, :page => page, :joins => [:media_file, :dynamic_special_image_spec],
                :conditions => ['media_files.name LIKE ? AND dynamic_special_image_specs.name = ?', "%#{search}%", image_type], 
                :order => sort_text
    end
  end

  def self.media_name_exists?(name)
    test = find :all, :joins => :media_file,
                :conditions => ['media_files.name = ?', name]
    test.length > 0
  end            

  def self.highest_number(search, image_type)
    list = find :all, :joins => [:media_file, :dynamic_special_image_spec],
                :conditions => ['media_files.filename LIKE ? AND dynamic_special_image_specs.name = ?', "#{search}%", image_type]
    max = 0
    list.each do |item|
      filename = item.media_file.filename
      number = filename.map {|x| x[/\d+/]}.first.to_i
      if number > max 
        max = number
      end
    end
    max
  end

  def self.next_picture_prefix(search, image_type)
    number = highest_number(search, image_type)
    search +   "%02d" % (number + 1) + '_'
  end

end
