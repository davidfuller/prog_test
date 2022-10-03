xml.instruct! :xml, :version => "1.0"

  xml.statuses do
    if @statuses
      @statuses.each do |status|
        xml.item do
          xml.id status.id
          xml.message status.message
          xml.value status.value
        end
      end
    end
  end
