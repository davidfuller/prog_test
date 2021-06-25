xml.instruct! :xml, :version => "1.0"

  xml.media_files do
    if @media_files
      @media_files.each do |media_file|
        if media_file.automated_dynamic_special
          data = media_file.automated_dynamic_special.data_for_preview
          xml.item do
            xml.name data[:name]
            xml.page data[:page]
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
  
      