xml.instruct! :xml, :version => "1.0"

  xml.houses do
    for house in @houses
      xml.item do
        xml.house_number house.house_number
        if house.title
          xml.title_id house.title_id
          xml.english house.title.english
          xml.danish house.title.danish
          xml.swedish house.title.swedish
          xml.norwegian house.title.norwegian
          xml.hungarian house.title.hungarian
          xml.eop house.title.eop_boolean
        end
      end
    end

end

        
      