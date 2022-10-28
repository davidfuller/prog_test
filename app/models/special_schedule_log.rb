class SpecialScheduleLog < ActiveRecord::Base

  belongs_to :channel
  
  def self.add_note(params, notes)
    log = self.new
    channel = Channel.find_by_name(params[:channel])
    log.channel_id = channel.id
    log.start_date = Time.parse(params[:start_date])
    log.end_date = Time.parse(params[:end_date])
    log.start_time = Time.parse(params[:start_time])
    #log.end_time = Time.parse(params[:end_time])
    log.long_notes = notes
    if log.save
      log.id
    else
      nil
    end
  end

end
