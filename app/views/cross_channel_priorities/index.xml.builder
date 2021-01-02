xml.instruct! :xml, :version => "1.0"

  xml.cross_channel_priorities do
    for priority in @cross_channel_priorities
      xml.item do
        xml.billed_time   priority.billed
        xml.channel_id    priority.channel_id
        xml.title_id      priority.title_id
        xml.lead_text     priority.lead_text
        xml.series_ident  priority.series_ident
        xml.local_title   priority.local_title_display
        xml.english_title priority.title_display
        xml.eidr					priority.eidr
      end
    end
  
    
end

        
