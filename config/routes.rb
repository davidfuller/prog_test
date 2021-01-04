ActionController::Routing::Routes.draw do |map|
  map.resources :dynamic_special_medias

  map.resources :dynamic_special_logos

  map.resources :automated_dynamic_special_fields

  map.resources :automated_dynamic_specials

  map.resources :template_field_joins

  map.resources :dynamic_special_templates

  map.resources :dynamic_special_fields

  map.resources :dynamic_special_image_specs

  map.resources :clipsources

  map.resources :on_demand_schedulings

  map.resources :channel_on_demands

  map.resources :on_demand_files

  map.resources :services

  map.resources :on_demands, :member => {:add_promo => :get, :edit_on_demand => :get, :delete_promo => :delete, :create_promo => :get, :unlink_promo => :delete, :show_on_demand => :get }

  map.resources :channel_special_previews

  map.resources :special_previews

  map.resources :diva_polls

  map.resources :diva_logs

  map.resources :diva_tasks

  map.resources :diva_settings

  map.resources :diva_datas

  map.resources :diva_statuses

  map.resources :trailer_house_number_prefixes

  map.resources :channel_trailers

  map.resources :trailer_files

  map.resources :trailers, :collection => {:delete_all_not_available => :delete, :diva_media_search => :get, 
                                            :diva_workflow => :get, :delete_diva_references => :delete,
                                            :diva_workflow_update => :get } #, :member => {:diva_media_search => :get}

  map.resources :trailer_tab_settings

  map.resources :exception_lists

  map.resources :dynamic_specials, :collection => { :duplicate => :get }
  
  map.resources :special_fields
  
  map.resources :series_idents, :collection => {:destroy_all => :get, :add_dummy => :get }, 
                                :member => {:edit_from_title => :get, :edit_from_comparison => :get, 
                                            :edit_series => :get, :update_press_series => :get}

  map.resources :cross_channel_priorities

  map.resources :aspects

  map.resources :statuses

  map.resources :promos,  :collection => { :last_use => :get, :add_all_series_idents => :get, :delete_all_series_idents => :delete }, 
                          :member => {:add_series_idents => :get }

  map.resources :media_types

  map.resources :priorities

  map.resources :series_numbers

  map.resources :series_numbers

  map.resources :schedule_comparisons, :member => {:keep_series => :get, :delete_house => :get, :add_eidr => :get }

  map.resources :schedule_files

  map.resources :schedule_lines

  map.resources :schedule_tab_settings

  map.resources :countdown_ipps

  map.resources :media_files, :collection => { :unready => :get, :last_use => :get, :move_2012 => :get }

  map.resources :media_folders

  map.resources :commons

  map.resources :jpegs

  map.resources :jpeg_folders

  map.resources :bugs

  map.resources :press_filenames

  map.resources :playlist_filenames

  map.resources :channels

  map.resources :languages

  map.resources :houses, :collection => {:add_all_series_ident => :get },
                         :member => {:new_from_comparison => :get}

  map.resources :titles, :member => {:new_series => :get, :add_promo => :get, :delete_promo => :delete, :search_promo => :get, 
                                     :edit_title => :get, :create_series_ident => :get, :delete_series_ident => :delete,
                                     :change_series_ident => :get, :choose => :get, :edit_title_house_or_series_known => :get, 
                                     :update_press_title => :get, :new_from_press => :get, :clone => :get, :auto_add_local_discrepancy_multiple => :get,
                                     :auto_add_local_discrepancy => :get, :stored_local => :get, :update_multiple_press_title => :get}

  map.resources :ignores

  map.resources :comparisons, :member => {:add_series =>:get, :add_title_series => :get, :add_local_title => :get, :add_eidr_to_house => :get }
  
  map.resources :press_lines, :collection => { :priority => :get, :cross_channel_selection => :get }

  map.resources :playlist_lines

  map.resources :playlist_position_settings

  map.resources :press_tab_settings

  map.resources :uploads
  
  map.resources :previews

  map.resources :preview_jpegs  
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => "previews"
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
