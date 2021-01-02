# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
   
   def select_tag_for_filter(model, nvpairs, params)
     options = { :query => params[:query] }
     _url = url_for(eval("#{model}_url(options)"))
     _html = %{<label for="show">Show:</label><br />}
     _html << %{<select name="show" id="show"}
     _html << %{onchange="window.location='#{_url}' + '?show=' + this.value">}
     nvpairs.each do |pair|
       _html << %{<option value="#{pair[:scope]}"}
       if params[:show] == pair[:scope] || ((params[:show].nil? ||
   params[:show].empty?) && pair[:scope] == "all")
         _html << %{ selected="selected"}
       end
       _html << %{>#{pair[:label]}}
       _html << %{</option>}
     end
     _html << %{</select>}
   end   
   
   def select_date_to_date(form_date)
     Date.new(form_date[:"start_date(1i)"].to_i, form_date[:"start_date(2i)"].to_i, form_date[:"start_date(3i)"].to_i)
   rescue 
     nil
   end
  
   def page_date_heading(date)
     format_date_time(date, "%A %d %B %Y") unless date.nil? 
   end
   
#   def titles_path_with_language
#      {:controller => :titles, :action => :index, :language => session[:language]}
#   end

end
