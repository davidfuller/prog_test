xml.instruct! :xml, :version => "1.0"

xml.automated_dynamic_specials do
  for dynamic_special in @automated_dynamic_specials
    xml.item do
      xml.id dynamic_special.id
      xml.name fool_excel_prefix(dynamic_special.name)
      xml.channel dynamic_special.channel_name
      if dynamic_special.dynamic_special_template
        xml.page_169 dynamic_special.dynamic_special_template.page_169
        xml.clear_down_page_number_169 dynamic_special.dynamic_special_template.clear_down_169
        xml.page_43 dynamic_special.dynamic_special_template.page_43
        xml.clear_down_page_number_43 dynamic_special.dynamic_special_template.clear_down_43
        xml.clear_down_duration dynamic_special.dynamic_special_template.duration
      end
      dynamic_special.automated_dynamic_special_fields.each do |special_field|
        xml.special_field do
          xml.number special_field.field_number
          xml.description fool_excel_prefix(special_field.field_name)
          xml.default_text fool_excel_prefix(special_field.field_value)
        end
      end
      xml.media_status fool_excel_prefix(dynamic_special.promo_media_status)
    end
  end 
end
