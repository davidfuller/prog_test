module SeriesIdentsHelper
  
  def show_press_year?
      @press && @series_ident.year_number != @press.year_number
  end
  
  def press_year_number(year_number)
    "Press listings year: " + year_number 
  end
end
