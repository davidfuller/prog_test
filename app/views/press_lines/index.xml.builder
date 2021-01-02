xml.instruct! :xml, :version => "1.0"

  xml.press_lines do
    for press_line in @press_lines
      xml.item do
        xml.start press_line.start
        xml.display_title press_line.display_title
        xml.original_title press_line.original_title
        xml.lead_text press_line.lead_text
        if press_line.priority.nil?
          xml.priority false
        else
          xml.priority press_line.priority
        end
        if press_line.channel.nil?
          xml.channel ""
        else
          xml.channel press_line.channel_name
        end
        xml.series_ident press_line.series_number
        if press_line.audio_priority.nil?
          xml.audio_priority false
        else
          xml.audio_priority press_line.audio_priority
        end
        xml.eidr press_line.eidr
        #xml.filename press_line.press_filename_id
      end
    end
end

        
