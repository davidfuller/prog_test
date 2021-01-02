xml.instruct! :xml, :version => "1.0"

xml.houses do
  for title in @titles
    for series in title.series_idents
      for house in series.houses
        xml.item do
          xml.title_id title.id
          xml.english title.english
          xml.danish title.danish
          xml.swedish title.swedish
          xml.norwegian title.norwegian
          xml.hungarian title.hungarian
          xml.eop title.eop_boolean
          xml.description title.description     
          xml.updated_at title.updated_at
          xml.created_at title.created_at 
          xml.house_id house.id
          xml.house_number house.house_number
          xml.house_updated_at house.updated_at
          xml.house_created_at house.created_at
          xml.series_ident_id series.id
          xml.series_ident_number series.number
          xml.series_ident_year series.year_number
          xml.series_ident_discription series.description
          xml.series_ident_eidr series.eidr
          xml.series_ident_updated_at series.updated_at
          xml.series_ident_created_at series.created_at
        end
      end
    end
  end    
end

        
