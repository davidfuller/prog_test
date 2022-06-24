# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20220524104931) do

  create_table "aspects", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_suffix"
  end

  create_table "automated_dynamic_special_fields", :force => true do |t|
    t.string   "the_value"
    t.integer  "automated_dynamic_special_id"
    t.integer  "template_field_join_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "the_id"
    t.string   "the_display"
  end

  create_table "automated_dynamic_specials", :force => true do |t|
    t.string   "name"
    t.integer  "channel_id"
    t.datetime "last_use"
    t.integer  "dynamic_special_template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "special_preview_id"
    t.boolean  "archive"
  end

  create_table "bugs", :force => true do |t|
    t.string   "name"
    t.integer  "page_number"
    t.integer  "channel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channel_on_demands", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "on_demand_id"
    t.boolean  "enable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channel_special_previews", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "special_preview_id"
    t.boolean  "enable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channel_trailers", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "trailer_id"
    t.boolean  "enable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channels", :force => true do |t|
    t.string   "name"
    t.string   "press_code"
    t.string   "playlist_code"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "domain"
    t.string   "path"
    t.string   "bss_name"
    t.boolean  "hd"
    t.string   "prefix"
    t.string   "logo_filename"
    t.boolean  "circle_logo"
    t.string   "encoding"
    t.boolean  "has_dynamic_branding"
    t.string   "clipsource_domain"
    t.string   "clipsource_path"
    t.string   "clipsource_suffix"
  end

  create_table "clipsources", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commons", :force => true do |t|
    t.string   "english"
    t.string   "danish"
    t.string   "swedish"
    t.string   "norwegian"
    t.string   "hungarian"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comparisons", :force => true do |t|
    t.datetime "start"
    t.datetime "rounded"
    t.string   "long_title"
    t.string   "house_no"
    t.datetime "press_start"
    t.string   "original_title"
    t.string   "danish_title"
    t.boolean  "contained"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "found_house"
    t.boolean  "found_title"
    t.integer  "channel_id"
    t.string   "series_ident"
    t.string   "year"
    t.string   "comparison_code"
    t.integer  "press_id"
  end

  create_table "countdown_ipps", :force => true do |t|
    t.string   "name"
    t.integer  "channel_id"
    t.datetime "first_use"
    t.datetime "last_use"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countdown_ipps_media_files", :id => false, :force => true do |t|
    t.integer  "countdown_ipp_id"
    t.integer  "media_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cross_channel_priorities", :force => true do |t|
    t.datetime "billed"
    t.string   "original_title"
    t.string   "local_title"
    t.string   "lead_text"
    t.integer  "channel_id"
    t.integer  "tx_channel_id"
    t.integer  "press_id"
    t.integer  "title_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "series_ident"
    t.string   "eidr"
  end

  create_table "diva_datas", :force => true do |t|
    t.string   "system_id"
    t.string   "diva_house_number"
    t.integer  "diva_duration"
    t.string   "tv_standard"
    t.integer  "diva_status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "xml_string"
    t.integer  "job_id"
    t.string   "status"
    t.datetime "job_created"
    t.datetime "job_started"
    t.datetime "job_completed"
    t.text     "job_xml_string"
  end

  create_table "diva_logs", :force => true do |t|
    t.string   "action"
    t.integer  "trailer_id"
    t.string   "uri"
    t.text     "xml_sent"
    t.string   "net_message"
    t.text     "xml_received"
    t.string   "filename"
    t.string   "data_message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "diva_status_id"
  end

  create_table "diva_polls", :force => true do |t|
    t.integer  "media_search"
    t.integer  "workflow_start"
    t.integer  "workflow"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "media_details"
    t.text     "workflow_start_details"
    t.text     "workflow_details"
  end

  create_table "diva_settings", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text_value"
  end

  create_table "diva_statuses", :force => true do |t|
    t.integer  "value"
    t.string   "message"
    t.boolean  "seach"
    t.boolean  "workflow"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "css"
    t.text     "description"
  end

  create_table "diva_tasks", :force => true do |t|
    t.integer  "system_id"
    t.string   "task_type"
    t.string   "name"
    t.integer  "task_index"
    t.datetime "completed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "diva_data_id"
  end

  create_table "dynamic_special_fields", :force => true do |t|
    t.string   "name"
    t.integer  "dynamic_special_image_spec_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "empty_allowed"
  end

  create_table "dynamic_special_image_specs", :force => true do |t|
    t.string   "name"
    t.integer  "height"
    t.integer  "width"
    t.boolean  "resizable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "image"
    t.string   "display_folder"
    t.boolean  "logo"
    t.boolean  "promo"
    t.integer  "media_folder_id"
    t.string   "upload_folder"
  end

  create_table "dynamic_special_logos", :force => true do |t|
    t.string   "name"
    t.string   "filename"
    t.string   "display_filename"
    t.integer  "dynamic_special_image_spec_id"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dynamic_special_medias", :force => true do |t|
    t.integer  "media_file_id"
    t.integer  "dynamic_special_image_spec_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dynamic_special_templates", :force => true do |t|
    t.string   "name"
    t.integer  "page_169"
    t.integer  "clear_down_169"
    t.integer  "page_43"
    t.integer  "clear_down_43"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "demo"
    t.string   "help_message"
  end

  create_table "dynamic_specials", :force => true do |t|
    t.string   "name"
    t.integer  "channel_id"
    t.integer  "page"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clear_down_page_number"
    t.integer  "clear_down_duration"
    t.integer  "page_43"
    t.integer  "clear_down_page_number_43"
    t.string   "sponsor"
    t.string   "sponsor_reference"
    t.datetime "last_use"
  end

  create_table "exception_lists", :force => true do |t|
    t.datetime "entry_time"
    t.string   "channel_name"
    t.string   "eidr"
    t.string   "house_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "message"
    t.string   "existing_title"
    t.string   "clipsource_title"
  end

  create_table "houses", :force => true do |t|
    t.string   "house_number"
    t.integer  "title_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "series_number_id"
    t.integer  "series_ident_id"
  end

  create_table "ignores", :force => true do |t|
    t.string   "word"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jpeg_folders", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jpegs", :force => true do |t|
    t.string   "name"
    t.string   "filename"
    t.integer  "jpeg_folder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "code"
  end

  create_table "media_files", :force => true do |t|
    t.string   "name"
    t.string   "filename"
    t.integer  "media_folder_id"
    t.datetime "first_use"
    t.datetime "last_use"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
    t.integer  "media_type_id"
    t.string   "original_filename"
    t.string   "audio_filename"
    t.boolean  "has_audio"
  end

  create_table "media_files_promos", :id => false, :force => true do |t|
    t.integer  "media_file_id"
    t.integer  "promo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_folders", :force => true do |t|
    t.string   "name"
    t.string   "folder"
    t.integer  "channel_id"
    t.boolean  "clip"
    t.boolean  "system"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "aspect_id"
  end

  create_table "media_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "on_demand_files", :force => true do |t|
    t.string   "filename"
    t.datetime "uploaded"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "on_demand_schedulings", :force => true do |t|
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default"
  end

  create_table "on_demands", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.integer  "service_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "navigation"
    t.string   "message"
    t.integer  "priority"
    t.boolean  "ecp"
    t.boolean  "menu"
    t.boolean  "ipp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order"
    t.integer  "on_demand_file_id"
    t.integer  "promo_id"
    t.string   "country_code"
    t.integer  "on_demand_scheduling_id"
    t.string   "category"
  end

  create_table "playlist_filenames", :force => true do |t|
    t.string   "filename"
    t.date     "schedule_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "channel_id"
  end

  create_table "playlist_lines", :force => true do |t|
    t.integer  "event"
    t.datetime "start"
    t.time     "duration"
    t.string   "source"
    t.string   "material_type"
    t.string   "house_no"
    t.string   "title"
    t.string   "long_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "rounded"
    t.integer  "part"
    t.time     "timecode"
    t.boolean  "full_programme"
    t.integer  "playlist_filename_id"
  end

  create_table "playlist_position_settings", :force => true do |t|
    t.string   "item"
    t.integer  "position"
    t.integer  "length"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "press_filenames", :force => true do |t|
    t.string   "filename"
    t.datetime "import_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "press_lines", :force => true do |t|
    t.datetime "start"
    t.string   "display_title"
    t.string   "original_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "channel_id"
    t.integer  "press_filename_id"
    t.string   "lead_text"
    t.boolean  "priority"
    t.string   "series_number"
    t.string   "year_number"
    t.boolean  "audio_priority"
    t.string   "eidr"
    t.string   "content_id"
  end

  create_table "press_tab_settings", :force => true do |t|
    t.string   "item"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clipsource_position"
  end

  create_table "priorities", :force => true do |t|
    t.datetime "start"
    t.integer  "press_filename_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "priority"
    t.boolean  "audio"
  end

  create_table "promos", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "title_id"
    t.datetime "first_use"
    t.datetime "last_use"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promos_series_idents", :id => false, :force => true do |t|
    t.integer  "promo_id"
    t.integer  "series_ident_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedule_comparisons", :force => true do |t|
    t.datetime "start"
    t.string   "title"
    t.string   "house_number"
    t.string   "series_number"
    t.datetime "press_start"
    t.string   "original_title"
    t.string   "local_title"
    t.boolean  "contained"
    t.boolean  "found_house"
    t.boolean  "found_series"
    t.boolean  "found_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "channel_id"
    t.string   "series_ident"
    t.string   "year"
    t.string   "comparison_code"
    t.integer  "press_id"
    t.integer  "schedule_file_id"
    t.string   "eidr"
  end

  create_table "schedule_files", :force => true do |t|
    t.string   "name"
    t.integer  "channel_id"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedule_lines", :force => true do |t|
    t.datetime "start"
    t.string   "house_no"
    t.string   "title"
    t.string   "series_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "series_number"
    t.integer  "schedule_file_id"
  end

  create_table "schedule_tab_settings", :force => true do |t|
    t.string   "item"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deletion_rule"
  end

  create_table "series_idents", :force => true do |t|
    t.string   "number"
    t.integer  "title_id"
    t.string   "year_number"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "eidr"
  end

  create_table "series_numbers", :force => true do |t|
    t.string   "series_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_filename"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "special_fields", :force => true do |t|
    t.integer  "number"
    t.string   "description"
    t.string   "default_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dynamic_special_id"
  end

  create_table "special_previews", :force => true do |t|
    t.string   "name"
    t.integer  "media_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.integer  "value"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "template_field_joins", :force => true do |t|
    t.integer  "field"
    t.integer  "dynamic_special_template_id"
    t.integer  "dynamic_special_field_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "fixed"
    t.boolean  "dropdown"
    t.string   "default_value"
  end

  create_table "titles", :force => true do |t|
    t.string   "english"
    t.string   "danish"
    t.string   "swedish"
    t.string   "norwegian"
    t.string   "hungarian"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "eop"
    t.string   "description"
  end

  create_table "trailer_files", :force => true do |t|
    t.string   "filename"
    t.datetime "uploaded"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trailer_house_number_prefixes", :force => true do |t|
    t.string   "prefix"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trailer_tab_settings", :force => true do |t|
    t.integer  "position"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "field_name"
  end

  create_table "trailers", :force => true do |t|
    t.string   "house_number"
    t.string   "title"
    t.datetime "change"
    t.string   "channels_text"
    t.string   "ingest_status"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trailer_file_id"
    t.boolean  "enable"
    t.datetime "first_use"
    t.datetime "last_use"
    t.integer  "media_file_id"
    t.integer  "diva_data_id"
  end

  create_table "upload_playlist_files", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
