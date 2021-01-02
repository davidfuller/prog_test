module TrailersHelper

  def not_available_count
    (Trailer.find_all_by_enable(nil).count + Trailer.find_all_by_enable(false).count).to_s
  end

  def diva_orphaned_count
    Trailer.orphaned_diva_data.count
  end
end
