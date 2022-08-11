module GenerateStatusLinesHelper

  def next_day(date)
    (Time.parse(date) + 1.days).to_s(:broadcast_date_full_month)
  end
  
  def previous_day(date)
    (Time.parse(date) - 1.days).to_s(:broadcast_date_full_month)
  end

  def the_time_formatter(date, text)
    if date != Date.parse('11 February, 1960')
      date.in_time_zone('London').to_s(:broadcast_datetime)
    else
      text
    end
  end

end
