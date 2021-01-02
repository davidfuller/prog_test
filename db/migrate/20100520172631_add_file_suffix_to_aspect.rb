class AddFileSuffixToAspect < ActiveRecord::Migration

  def self.up
      add_column :aspects, :file_suffix, :string
  end

  def self.down
      remove_column :aspects, :file_suffix
  end
  
end
