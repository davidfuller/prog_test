class PressFilename < ActiveRecord::Base
  
  has_one :press_line
  
  def base
    File.basename(filename)
  end
  
  def self.convert_to_base
    files = all
    files.each do |f|
      f.filename = f.base
      f.save
    end
  end
  
end
