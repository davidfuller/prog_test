class GenerateStatusLine < ActiveRecord::Base

  belongs_to :channel
  default_scope :order => "channel_order"

  def self.search(tx_date)
    destroy_all(:status => 'Missing')
    if tx_date && tx_date != ''
      lines = find_all_by_tx_date(Date.parse(tx_date))
    else
      lines = all
    end
    
    test_channels = GenerateStatusSetting.all
    test_channels.each do |channel|
      if !lines.any? {|line| line[:channel_id] == channel.channel_id}
        logger.debug "Missing channel " + channel.channel.name
        my_line = GenerateStatusLine.new
        my_line.short_filename = ''
        my_line.full_filename = ''
        my_line.channel_id = channel.channel_id
        my_line.status = 'Missing'
        my_line.tx_date = Date.parse(tx_date)
        my_line.channel_order = channel.channel_order
        my_line.save
      end
    end

    if tx_date && tx_date != ''
      lines = find_all_by_tx_date(Date.parse(tx_date))
    else
      lines = all
    end
  end

  def self.generate_data(the_lines)
    issues = 0
    generate_time = Date.parse('11 February, 1960')
    poll_time = Date.parse('11 February, 1960')
    file_time = Date.parse('11 February, 1960')
    the_lines.each do |line|
      if line[:status] != 'Complete'
        issues += 1
      end
      if line[:generate_date_time] && line[:generate_date_time] > generate_time
        generate_time = line[:generate_date_time]
      end
      if line[:poll_date_time] && line[:poll_date_time] > poll_time
        poll_time = line[:poll_date_time]
      end
      if line[:file_modified_date_time] && line[:file_modified_date_time] >file_time
        file_time = line[:file_modified_date_time]
      end
    end
    {:issues => issues, :generate_time => generate_time, :poll_time => poll_time, :file_time => file_time}
  end

  def self.filter_top_letter(the_lines)
    test_channels = GenerateStatusSetting.all
    test_channels.each do |channel|
      these_lines = the_lines.find_all {|line| line[:channel_id] == channel.channel_id}
      if these_lines.length > 1
        delete_this = []
        max_version = ''
        these_lines.each do |this_line|
          if this_line.tx_version > max_version
            max_version = this_line.tx_version
          end
        end
        these_lines.each do |this_line|
          if this_line.tx_version != max_version
            delete_this << this_line
          end
        end
        delete_this.each do |my_delete|
          the_lines.delete(my_delete)
        end
      end
    end
    the_lines

  end

  def self.process
    poll_date_time = Time.current
    channels = GenerateStatusSetting.all(:conditions => { :enabled => true})
    filename = ''
    rails_filename = ''
    xml_string = ''
    modified_time = Time.current
    channels.each do |channel|
      if filename != channel.filename
        filename = channel.filename
        rails_filename = Rails.root.join(filename)
        xml_string = ''
        if File.file?(rails_filename)
          file = File.open(rails_filename, "r")
          modified_time = File.mtime(rails_filename)
          file.each_line do |line|
            xml_string += line
          end
        else
          xml_string = "No File"
        end
      end
    end
    hash_data = Hash.from_xml(xml_string)
    lines = hash_data["Complete_Job"]["Complete_Job"]

    new_array = []
    lines.each do |line|
      sheet_full_filename = line["Filename"]
      sheet_short_filename = sheet_full_filename[sheet_full_filename.rindex('\\') + 1..-1]
      my_setting = GenerateStatusSetting.find_prefix(sheet_short_filename)
      if my_setting
        sheet_date = Date.parse(sheet_short_filename[-12..-7], true) rescue nil
        if sheet_date
          new_array << sheet_date
          my_line = GenerateStatusLine.find_by_short_filename(sheet_short_filename)
          if !my_line
            my_line = GenerateStatusLine.new
          end
          my_line.short_filename = sheet_short_filename
          my_line.full_filename = sheet_full_filename
          my_line.channel_id = my_setting.channel_id
          my_line.poll_date_time = poll_date_time
          my_line.status = line['Status']
          my_line.generate_date_time = line['Creation_Timestamp']
          my_line.file_modified_date_time = modified_time
          my_line.tx_version = sheet_short_filename[-6..-6]
          my_line.tx_date = sheet_date
          my_line.channel_order = my_setting.channel_order
          my_line.save
        end
      end
    end
    
    new_array

    
  end

end
