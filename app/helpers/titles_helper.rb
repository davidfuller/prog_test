module TitlesHelper
  
  def show_fix_discrepancy?
    show_press?(:english) || show_press?(:danish) || show_press?(:swedish) || show_press?(:hungarian) || show_press?(:norwegian)
  end
  
  def show_press?(language)
    case language
    when :english
      @press && @title.english != @press.original_title
    when :danish
      @title.channel && @title.language == "Danish" && @press && @title.danish != @press.display_title
    when :swedish
      @title.channel && @title.language == "Swedish" && @press && @title.swedish != @press.display_title
    when :hungarian
      @title.channel && @title.language == "Hungarian" && @press && @title.hungarian != @press.display_title
    when :norwegian
      @title.channel && @title.language == "Norwegian" && @press && @title.norwegian != @press.display_title
    else
      false
    end
  end
  
  def press_title(title)
    "Press title: " + title    
  end
      
end
