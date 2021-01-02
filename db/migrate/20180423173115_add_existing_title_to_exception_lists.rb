class AddExistingTitleToExceptionLists < ActiveRecord::Migration
  def self.up
    add_column :exception_lists, :existing_title, :string
    add_column :exception_lists, :clipsource_title, :string
    remove_column :exception_lists, :original_title
    remove_column :exception_lists, :clipsource_original_title
    remove_column :exception_lists, :local_title
    remove_column :exception_lists, :clipsource_local_title
  end

  def self.down
    remove_column :exception_lists, :clipsource_title
    remove_column :exception_lists, :existing_title
    add_column :exception_lists, :original_title, :string
    add_column :exception_lists, :clipsource_original_title, :string
    add_column :exception_lists, :local_title, :string
    add_column :exception_lists, :clipsource_local_title, :string
  end
end
