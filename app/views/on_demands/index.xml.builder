xml.instruct! :xml, :version => "1.0"

xml.on_demands do
  for on_demand in @on_demands
    xml.item do
      xml.id on_demand.id
      xml.order on_demand.order
      xml.name on_demand.name
      xml.title on_demand.title
      xml.service on_demand.service.name unless on_demand.service.nil?
      xml.start_date on_demand.start_date
      xml.end_date on_demand.end_date
      xml.navigation on_demand.navigation
      xml.message on_demand.message
      xml.priority on_demand.priority
      xml.ecp on_demand.ecp
      xml.menu on_demand.menu
      xml.ipp on_demand.ipp
      xml.updated_at on_demand.updated_at
      xml.created_at on_demand.created_at
      xml.logo_filename on_demand.service.logo_filename unless on_demand.service.nil?
      xml.promo_id on_demand.promo_id unless on_demand.promo_id.nil?
      xml.scheduling on_demand.scheduling_message
    end
  end
end