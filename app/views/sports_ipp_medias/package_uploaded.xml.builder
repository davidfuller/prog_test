xml.instruct! :xml, :version => "1.0"

  xml.sports_ipp_medias do
    if @sports_ipp_media
      xml.item do
        xml.id @sports_ipp_media.id
        xml.filename @sports_ipp_media.filename
        xml.status @sports_ipp_media.sports_ipp_status.message if @sports_ipp_media.sports_ipp_status.present?
      end
    end
  end