xml.instruct! :xml, :version => "1.0"

xml.promos do
  for promo in @promos
    for series in promo.series_idents
      xml.item do
        xml.id promo.id
        xml.name promo.name
        xml.description promo.description
        xml.first_use promo.first_use
        xml.last_use promo.last_use
        xml.title_id series.title_id
        xml.series_ident_id series.id
        xml.english series.title.english unless series.title.nil?
        xml.updated_at promo.updated_at
        xml.created_at promo.created_at
        promo.media_files.each do |media_file|
          if !@portrait||media_file.media_type_id == 4
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
    for od in promo.on_demands
      xml.item do
        xml.id promo.id
        xml.name promo.name
        xml.description promo.description
        xml.first_use promo.first_use
        xml.last_use promo.last_use
        xml.title_id -1
        xml.series_ident_id -1
        xml.english od.title unless od.title.nil?
        xml.updated_at promo.updated_at
        xml.created_at promo.created_at
        promo.media_files.each do |media_file|
          if !@portrait||media_file.media_type_id == 4
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
  end
end
