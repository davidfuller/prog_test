xml.instruct! :xml, :version => "1.0"

  xml.dynamic_specials do
    for dynamic_special in @dynamic_specials
      xml.item do
        xml.id dynamic_special.id
        xml.name fool_excel_prefix(dynamic_special.name)
        xml.channel dynamic_special.channel_name
        xml.sponsor fool_excel_prefix(dynamic_special.sponsor)
        xml.sponsor_reference fool_excel_prefix(dynamic_special.sponsor_reference)
        xml.page_169 dynamic_special.page
        xml.clear_down_page_number_169 dynamic_special.clear_down_page_number
        xml.page_43 dynamic_special.page_43
        xml.clear_down_page_number_43 dynamic_special.clear_down_page_number_43
        xml.clear_down_duration dynamic_special.clear_down_duration
        dynamic_special.special_fields.each do |special_field|
          xml.special_field do
            xml.number special_field.number
            xml.description fool_excel_prefix(special_field.description)
            xml.default_text fool_excel_prefix(special_field.default_text)
          end
        end
      end
    end 
  end
  
