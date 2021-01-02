class CrossChannelPriority < ActiveRecord::Base
 
  validates_presence_of :title_id,  :message => "must be selected"
  validates_presence_of :tx_channel_id, :message => "must be selected"
  validates_presence_of :channel_id, :message => "to promote must be selected"
  validates_presence_of :billed,  :message => "time/date can't be blank"
  
  belongs_to :channel 
  belongs_to :title, :class_name => "Title", :foreign_key => "title_id"
  
  default_scope :order => :billed
  
  attr_accessor :cross_priority_date
  
  def self.search(params)

    search = params[:cross_search]
    channel = get_channel(params[:cross_tx_channel])
    cross_priority_date = params[:cross_priority_date]
    
    if search
      if cross_priority_date.blank?
        find(:all,  :joins => :title,
                    :conditions => ['titles.english LIKE ? and tx_channel_id = ?', "%#{search}%", channel.id])
      else
        date = Date.parse(cross_priority_date).strftime('%F')
        find(:all,  :joins => :title,
                    :conditions => ['titles.english LIKE ? and DATE(billed) >= ? and tx_channel_id = ?', "%#{search}%", date, channel.id])
      end
    else
      if cross_priority_date.blank?
        find(:all, :conditions => ['tx_channel_id = ?', channel.id])
      else
        date = Date.parse(cross_priority_date).strftime('%F')
        find(:all, :conditions => ['DATE(billed) >= ? and tx_channel_id = ?', date, channel.id])
      end
    end
  end
  
  def billed_display
    if billed
      billed.to_s(:broadcast_datetime)
    else
      ''
    end
  end
  
  def billed_display_for_press_lines
    if billed
      billed.to_s(:broadcast_date_full_month)
    else
      Time.now.to_s(:broadcast_date_full_month)
    end
  end
  
  def channel_display
    if channel
      channel.name
    else
      ''
    end
  end
  
  def tx_channel_display
    if tx_channel_id
      Channel.find(tx_channel_id).name || ''
    else
      ''
    end
  end
  
  def title_display
    if title
      title.english || ''
    else
      ''
    end
  end
  
  def local_title_display
    
    if channel && channel.language && title
      case channel.language.name
      when "Danish"
        title.danish || ''
      when "Swedish"
        title.swedish || ''
      when "Hungarian"
        title.hungarian || ''
      when "Norwegian"
        title.norwegian || ''
      else
        title.english || ''
      end
    else
      ''
    end
  end
  
  def self.get_channel(channel_name)
    channel = Channel.find_by_name(channel_name)
    if channel.nil?
      channel = Channel.first
    end
    channel
  end
end
