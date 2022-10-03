xml.instruct! :xml, :version => "1.0"

  xml.media_files do
    if @media_file
      xml.item do
        xml.id @media_file.id
        xml.name @media_file.name
        xml.filename @media_file.filename
        xml.original_filename @media_file.original_filename
        xml.status @media_file.status.message unless @media_file.status.nil?
        xml.first_use @media_file.first_use
        xml.last_use @media_file.last_use
      end
    end
  end