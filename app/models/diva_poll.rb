class DivaPoll < ActiveRecord::Base

  default_scope :order => 'updated_at DESC'

  def self.last_poll
    first.updated_at
  end

  def self.all_paged(page)
    paginate  :all, :per_page => 30, :page => page
  end

  def self.time_passed_since_last_poll(num_minutes)
    if first
      (first.updated_at + num_minutes.minutes) < Time.now
    else
      true
    end
  end

  def self.poll_status_message
    poll_interval_issue_time_minutes = DivaSetting.poll_interval_issue_time_minutes
    if self.time_passed_since_last_poll(poll_interval_issue_time_minutes)
      if first
        'Diva Poll Issue: ' + ((Time.now - self.last_poll)/1.minutes).to_i.to_s + ' mins since poll'
      else
        'Never polled'
      end
    else
      'Diva Poll OK'
    end
  end
end
