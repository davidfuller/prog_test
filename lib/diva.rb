

puts Time.now
poll_interval = DivaSetting.poll_interval_minutes
puts "Poll interval: " + poll_interval.to_s

num_days = DivaSetting.delete_poll_data_after_days
num_deleted = DivaPoll.destroy_all(['updated_at < ?', num_days.days.ago]).count

if num_deleted > 0 then
  puts num_deleted.to_s + " Poll log records deleted that were over " + num_days.to_s + " days old"
end

if poll_interval > 0
  if DivaPoll.time_passed_since_last_poll(poll_interval)
    poll = DivaPoll.new

    media_search = Trailer.requires_diva_data.count
    workflow_start = Trailer.requires_workflow_start.count
    workflow_update = Trailer.clarity_transfer_not_complete.count
    poll.media_search = media_search
    poll.workflow_start = workflow_start
    poll.workflow = workflow_update

    

    if media_search > 0
      puts 'Do the Media Search'
      details = DivaData.media_search
      poll.media_details = details
    end

    if workflow_start > 0
      puts 'Do the Workflow Start'
      details = DivaData.workflow
      poll.workflow_start_details = details
    end

    if workflow_update > 0
      puts 'Do the Workflow Update'
      details = DivaData.workflow_update
      poll.workflow_details = details
    end
    puts 'Ended'
    poll.save
  else
    puts 'Not polled'
  end
end