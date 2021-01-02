class AddAudioToMediaFiles < ActiveRecord::Migration
  def self.up
    add_column :media_files, :audio_filename, :string
    add_column :media_files, :has_audio, :boolean
  end

  def self.down
    remove_column :media_files, :has_audio
    remove_column :media_files, :audio_filename
  end
end
