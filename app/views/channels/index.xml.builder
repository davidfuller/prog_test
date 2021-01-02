xml.instruct! :xml, :version => "1.0"

  xml.channels do
    for channel in @channels
      xml.item do                                                             
        xml.id              channel.id                                        
        xml.name            channel.name                                      
        xml.format          channel.hd_display                                
        xml.language        channel.language.name unless channel.language.nil?
        xml.logo_filename   channel.logo_filename                             
        xml.circle_logo     channel.circle_logo                               
      end
    end
end

        
