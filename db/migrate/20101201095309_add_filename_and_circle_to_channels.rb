class AddFilenameAndCircleToChannels < ActiveRecord::Migration
  def self.up
      add_column :channels, :logo_filename, :string
      add_column :channels, :circle_logo, :boolean
  end

  def self.down
      remove_column :channels, :logo_filename
      remove_column :channels, :circle_logo
  end
end
