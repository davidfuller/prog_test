module PressLinesHelper
  
  def next_day(date)
    (Time.parse(date) + 1.days).to_s(:broadcast_date_full_month)
  end
  
  def previous_day(date)
    (Time.parse(date) - 1.days).to_s(:broadcast_date_full_month)
  end
  
  def day_header(date)
    week = Date.parse(date.to_s).strftime('%V')
    format_date_time(date, "%A %d/%m/%Y") + '  Week ' + week
  end

  def one_week(date)
    (Time.parse(date) + 6.days).to_s(:broadcast_date_full_month)
  end
  
end
