class AddMessageToExceptionLists < ActiveRecord::Migration
  def self.up
    add_column :exception_lists, :message, :string
  end

  def self.down
    remove_column :exception_lists, :message
  end
end
