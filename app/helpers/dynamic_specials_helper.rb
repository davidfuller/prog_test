module DynamicSpecialsHelper

  def fool_excel_prefix(value)
    if value
      '|-|' + value
    else
      ""
    end
  end  


end
