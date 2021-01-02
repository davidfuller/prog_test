xml.instruct! :xml, :version => "1.0"

xml.trailers do
  for trailer in @trailers
    media_file = trailer.media_file
    if media_file
      xml.item do
        xml.id trailer.id
        xml.title trailer.title
        xml.house_number trailer.house_number
        xml.first_use trailer.first_use
        xml.last_use trailer.last_use
        xml.duration trailer.duration
        xml.updated_at trailer.updated_at
        xml.created_at trailer.created_at
        xml.media_file do
          xml.name  media_file.name
          xml.filename  media_file.filename
          xml.folder media_file.media_folder.folder unless media_file.media_folder.nil?
          xml.first_use media_file.first_use
          xml.last_use media_file.last_use
          xml.status media_file.status.message unless media_file.status.nil?
          xml.media_type media_file.media_type.name unless media_file.media_type.nil?
          xml.media_id media_file.id
          if media_file.has_audio.nil?
            xml.has_audio false
          else
            xml.has_audio media_file.has_audio unless media_file.has_audio.nil?
          end
          xml.audio_filename media_file.audio_filename unless media_file.audio_filename.nil?
          xml.media_updated_at media_file.updated_at
          xml.media_created_at media_file.created_at
        end
      end
    end
  end
end