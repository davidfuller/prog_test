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
  
  def monday_this_week(date)
    monday_this_week_as_time(date).to_s(:broadcast_date_full_month)
  end

  def monday_this_week_as_time(date)
    the_date = Time.parse(date)
    if the_date.wday == 0
      monday = the_date - 6.days
    else
      monday = the_date - (the_date.wday - 1).days
    end
  end
end
