class AddOriginalFilenameToSportsIppMedia < ActiveRecord::Migration
  def self.up
    add_column :sports_ipp_medias, :original_filename, :string
  end

  def self.down
    remove_column :sports_ipp_medias, :original_filename
  end
end
