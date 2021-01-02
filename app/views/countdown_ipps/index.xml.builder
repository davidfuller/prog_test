xml.instruct! :xml, :version => "1.0"

  xml.countdown_ipps do
    for countdown_ipp in @countdown_ipps
      for media_file in countdown_ipp.media_files
        xml.item do
          xml.id countdown_ipp.id
          xml.name countdown_ipp.name
          if countdown_ipp.channel
            xml.channel countdown_ipp.channel.name
          end
          xml.first_use countdown_ipp.first_use
          xml.last_use countdown_ipp.last_use
          if countdown_ipp.media_files
            xml.media_name media_file.name
            xml.media_file_name media_file.filename
            if media_file.media_folder
              xml.folder media_file.media_folder.folder
            end
            xml.media_first_use media_file.first_use
            xml.media_last_use media_file.last_use
          end
        end
      end
    end

end

        
