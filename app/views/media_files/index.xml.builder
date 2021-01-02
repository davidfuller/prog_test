xml.instruct! :xml, :version => "1.0"

  xml.media_files do
    if @media_files
      @media_files.each do |media_file|
        xml.file do
          xml.id media_file.id
          xml.name media_file.name
          xml.status_id media_file.status_id
          if media_file.status
            xml.status_message media_file.status.message
          end
        end
      end
    end
    if @statuses
      @statuses.each do |status|
        xml.status do
          xml.id status.id
          xml.message status.message
          xml.value status.value
        end
      end
    end
  end
  
      


  