class DynamicSpecial < ActiveRecord::Base

  default_scope :order => 'channel_id, page'
  belongs_to :channel
  has_many :special_fields
  
  validates_presence_of :name, :page, :channel_id
  
  def self.search(search, channel, page, show_duplicate, show_all, show_only)
    channel_id = Channel.find_by_name(channel)
    current_time = Time.current
    if show_duplicate
      if channel_id
        if search
          all :conditions => ['channel_id = ? AND name LIKE ?', channel_id, "%#{search}%"]
        else
          all :conditions => ['channel_id = ?', channel_id]
        end
      else
        if search then
          all :conditions => ['name LIKE ?', "%#{search}%"]
        else
          all
        end
      end
    else
      if channel_id
        if search
          if show_all
            if show_only #past last use
              paginate  :per_page => 12, :page => page, :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ?', channel_id, "%#{search}%", current_time]
            else
              paginate  :per_page => 12, :page => page, :conditions => ['channel_id = ? AND name LIKE ?', channel_id, "%#{search}%"]
            end
          else
            if show_only
              paginate  :per_page => 12, :page => page, :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ?', channel_id, "%#{search}%", current_time]
            else
              paginate  :per_page => 12, :page => page, :conditions => ['channel_id = ? AND name LIKE ? AND last_use >= ?', channel_id, "%#{search}%", current_time]
            end
          end 
        else # no search (almoost never)
          if show_all
            if show_only #past last use
              paginate  :per_page => 12, :page => page, :conditions => ['channel_id = ? AND last_use < ?', channel_id, current_time]
            else
              paginate  :per_page => 12, :page => page, :conditions => ['channel_id = ?', channel_id]
            end
          else
            if show_only
              paginate  :per_page => 12, :page => page, :conditions => ['channel_id = ? AND last_use < ?', channel_id, current_time]
            else
              paginate  :per_page => 12, :page => page, :conditions => ['channel_id = ? AND last_use >= ?', channel_id,  current_time]
            end
          end
        end
      else #all channels
        if search then
          if show_all
            if show_only # past last use
              paginate  :per_page => 12, :page => page, :conditions => ['name LIKE ? AND last_use < ?', "%#{search}%", current_time]
            else
              paginate  :per_page => 12, :page => page, :conditions => ['name LIKE ?', "%#{search}%"]
            end
          else
            if show_only # past last use
              paginate  :per_page => 12, :page => page, :conditions => ['name LIKE ? AND last_use < ?', "%#{search}%", current_time]
            else
              paginate  :per_page => 12, :page => page, :conditions => ['name LIKE ? AND last_use >= ?', "%#{search}%", current_time]
            end
          end
        else # no search (almoost never)
          if show_all
            if show_only # past last use
              paginate  :all, :per_page => 12, :page => page, :conditions => ['last_use < ?', current_time]
            else
              paginate  :all, :per_page => 12, :page => page 
            end
          else
            if show_only # past last use
              paginate  :all, :per_page => 12, :page => page, :conditions => ['last_use < ?', current_time]
            else
              paginate  :all, :per_page => 12, :page => page, :conditions => ['last_use >= ?', current_time]
            end
          end
        end
      end
    end
  end
  
  def channel_name
    if channel
      channel.name
    else
      ''
    end
  end
  
  def fix_nil_last_use
    if last_use.nil?
      if updated_at
        last_use = updated_at.to_date + 1.month + 1.day + 6.hours
      elsif created_at
        last_use = created_at.to_date + 1.month + 1.day + 6.hours
      else
        last_use = Time.current.to_date + 1.month + 1.day + 6.hours
      end
      self.last_use = last_use
    end
  end
  
  def self.fix_all_nil_last_use
    num = 0
    the_nulls = find(:all, :conditions => ['last_use IS NULL'])
    the_nulls.each do |ds|
      ds.fix_nil_last_use
      if ds.save
        num += 1
      end
    end
    {:num_nulls => the_nulls.count, :num_fixed => num}
  end
  
  def self.xml_data(channel)
    channel_id = Channel.find_by_name(channel)
    if channel_id
      all :conditions => ['channel_id = ?', channel_id], :order => 'id'
    else
      all :order => 'id'
    end 
  end
  
  
  def duplicate_message
    dupes = DynamicSpecial.count :conditions => ['channel_id = ? AND name LIKE ?', self.channel_id, self.name]
    if dupes > 1
      '<== Duplicate name on this channel'
    else
      ''
    end
  end
  
  def next_field_number
    if special_fields.count > 0
      current_max = 0
      special_fields.each do |field|
        if field.number > current_max
          current_max =field.number
        end
      end
      current_max+1
    else
      1
    end
  end
  
  def add_special_fields(original)
    original.special_fields.each do |sf|
      sf_new = SpecialField.find(sf).clone
      sf_new.dynamic_special_id = self.id
      sf_new.save
    end
  end
     
end
