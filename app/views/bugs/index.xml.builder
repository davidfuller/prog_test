xml.instruct! :xml, :version => "1.0"

  xml.bugs do
    for bug in @bugs
      xml.bug do
        if bug.channel
          xml.tag!('channel-id',    bug.channel.name)
        else
          xml.tag!('channel-id',    '')
        end
        xml.name                  bug.name
        xml.tag!('page-number',   bug.page_number)
      end
    end

end

        
