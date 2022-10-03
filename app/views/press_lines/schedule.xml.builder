xml.instruct! :xml, :version => "1.0"

  xml.schedule do
    for press_line in @press_lines
      xml.item do
        xml.id press_line.id
        xml.start press_line.start.to_s(:broadcast_xml_datetime)
        xml.display_title press_line.display_title
        xml.original_title press_line.original_title
        if press_line.channel.nil?
          xml.channel ""
        else
          xml.channel press_line.channel_name
        end
        press_line.specials.each do |special|
          xml.special do
            xml.special_id special.automated_dynamic_special_id
            xml.special_name special.automated_dynamic_special.name
            xml.part_name special.part.name
            xml.offset special.offset
          end
        end
      end
    end
end