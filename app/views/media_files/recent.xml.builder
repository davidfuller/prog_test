xml.instruct! :xml, :version => "1.0"

  xml.media_files do
    if @media_files
      @media_files.each do |media_file|
        if media_file.automated_dynamic_special
          data = media_file.automated_dynamic_special.data_for_preview
        elsif media_file.sports_ipp && media_file.sports_ipp.automated_dynamic_special
          data = media_file.sports_ipp.automated_dynamic_special.data_for_preview
        end
        if data
          xml.item do
            xml.id media_file.id
            xml.filename media_file.filename
            xml.name data[:name]
            xml.page data[:page]
            if media_file.sports_ipp && media_file.sports_ipp.sports_ipp_media
              xml.package_filename media_file.sports_ipp.sports_ipp_media.filename
              xml.sports_ipp true
            else
              xml.sports_ipp false
            end
            for i in 1..10 do
              if data[:fields][i].present?
                xml.fields do
                  xml.number i.to_s
                  xml.value fool_excel_prefix(data[:fields][i].to_s)
                end
              end
            end
          end
        end
      end
    end
  end
  
      