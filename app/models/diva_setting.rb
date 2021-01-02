class DivaSetting < ActiveRecord::Base

  default_scope :order => :name

  def self.duration_offset
    data = find_by_name('Duration Offset')
    if data
      data.value.to_i
    else
      0
    end
  end

  def self.media_search_node
    data = find_by_name('Media Search Node')
    if data
      data.value
    else
      ''
    end
  end

  def self.media_node
    data = find_by_name('Media Node')
    if data
      data.value
    else
      ''
    end
  end

  def self.house_number_attribute
    data = find_by_name('House Number Attribute')
    if data
      data.value
    else
      ''
    end
  end
  
  def self.system_id_attribute
    data = find_by_name('System ID Attribute')
    if data
      data.value
    else
      ''
    end
  end
  
  def self.duration_attribute
    data = find_by_name('Duration Attribute')
    if data
      data.value
    else
      ''
    end
  end
  
  def self.tv_standard_attribute
    data = find_by_name('TV Standard Attribute')
    if data
      data.value
    else
      ''
    end
  end

  def self.xml
    {:media_search => self.media_search_node, :media => self.media_node,
      :house => self.house_number_attribute, :id => self.system_id_attribute, 
      :dur => self.duration_attribute, :tv => self.tv_standard_attribute}
  end

  def self.job_node
    data = find_by_name('Job Node')
    if data
      data.value
    else
      ''
    end
  end

  def self.job_node
    data = find_by_name('Job Node')
    if data
      data.value
    else
      ''
    end
  end

  def self.job_id_attribute
    data = find_by_name('Job ID Attribute')
    if data
      data.value
    else
      ''
    end
  end

  def self.job_status_attribute
    data = find_by_name('Job Status Attribute')
    if data
      data.value
    else
      ''
    end
  end

  def self.job_started_attribute
    data = find_by_name('Job Started Attribute')
    if data
      data.value
    else
      ''
    end
  end

  def self.job_created_attribute
    data = find_by_name('Job Created Attribute')
    if data
      data.value
    else
      ''
    end
  end

  def self.job_completed_attribute
    data = find_by_name('Job Completed Attribute')
    if data
      data.value
    else
      ''
    end
  end

  def self.job_xml
    {:job => self.job_node, :job_id => self.job_id_attribute, :status => self.job_status_attribute, 
      :job_started => self.job_started_attribute, :job_created => self.job_created_attribute, :job_completed => self.job_completed_attribute }
  end

  def self.poll_interval_minutes
    data = find_by_name('Poll Interval Minutes')
    if data
      data.value.to_i
    else
      0
    end
  end

  def self.poll_interval_issue_time_minutes
    data = find_by_name('Poll Interval Issue Time Minutes')
    if data
      data.value.to_i
    else
      0
    end
  end
  
  def self.net_timeout_seconds
    data = find_by_name('Net Timeout Seconds')
    if data
      data.value.to_i
    else
      10
    end
  end

  def self.delete_poll_data_after_days
    data = find_by_name('Delete Poll Data After Days')
    if data
      data.value.to_i
    else
      365
    end
  end

  def self.valid_durations
    data = find_by_name('Allowed durations')
    if data
      values = []
      durations = data.value.split(',')
      durations.each do |d|
        if d.to_i != 0
          values << d.to_i
        end
      end
      values
    else
      []
    end
  end

end
