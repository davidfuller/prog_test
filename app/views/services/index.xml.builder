xml.instruct! :xml, :version => "1.0"

xml.services do
  for service in @services
    xml.item do
      xml.id service.id
      xml.name service.name
      xml.logo_filename service.logo_filename
      xml.updated_at service.updated_at
      xml.created_at service.created_at
    end
  end
end