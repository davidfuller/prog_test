class DivaData < ActiveRecord::Base
  require 'net/http'

  belongs_to :diva_status
  has_one :trailer
  has_many :diva_tasks

  attr_accessor :source
  attr_accessor :trailer_id

  def status_css
    if diva_status
      diva_status.css
    else
      ''
    end
  end

  def self.media_search
    trailers = Trailer.requires_diva_data
    trailers.each do |trailer|
      self.media_search_individual(trailer)
    end
    house_numbers_text(trailers)
  end

  def self.media_search_individual(trailer)
    result = self.net_media_search(trailer.house_number)
    Trailer.read_diva_data(trailer, result[:log])
  end

  def self.net_media_search(house_number)
    log = DivaLog.new
    log.action = 'Media Search'
    settings = media_search_settings
    log.uri = settings[:uri]
    uri = URI(settings[:uri])
    http = create_http(uri, settings[:timeout])
    req = Net::HTTP::Post.new(uri.path)
    xml_string=settings[:xml]
    xml_string.sub! '!!house_number!!', house_number
    log.xml_sent = xml_string
    req.body = xml_string
    req.content_type = 'text/xml'
    begin
      res = http.request(req)
      xml_return = res.body
      log.xml_received = xml_return
      filename = Rails.root.join('public','data', 'diva', 'search', house_number + '.xml')
      log.filename = Muvi2Generic.short_pathname(filename)
      file = File.new(filename, "wb")
      file.write(xml_return)
      file.close
      log.net_message = 'OK'
      success = true
    rescue Timeout::Error => e
      log.net_message = 'Timeout Error'
      success = false
    rescue
      log.net_message 'Other Error'
      success = false
    end
    if log.save
      {:log => log, :success => success}
    else
      {:log => nil, :success => false}
    end

  end

  def self.workflow
    trailers = Trailer.requires_workflow_start
    trailers.each do |trailer|
      self.workflow_individual(trailer)
    end
    self.house_numbers_text(trailers)
  end

  def self.workflow_individual(trailer)
    if trailer.diva_data && trailer.diva_data.system_id
      result = self.net_workflow(trailer.diva_data.system_id)
      Trailer.read_diva_workflow_data(trailer, true, result[:log])
    end
  end


  def self.net_workflow(diva_system_id)
    log = DivaLog.new
    log.action = 'Workflow Start'
    settings = workflow_settings
    log.uri = settings[:uri]
    uri = URI(settings[:uri])
    http = create_http(uri, settings[:timeout])
    req = Net::HTTP::Post.new(uri.path)
    xml_string=settings[:xml]
    xml_string.sub! '!!system_id!!', diva_system_id
    log.xml_sent = xml_string
    req.body = xml_string
    req.content_type = 'text/xml'
    begin
      res = http.request(req)
      xml_return = res.body
      log.xml_received = xml_return
      filename = Rails.root.join('public','data', 'diva', 'workflow', diva_system_id + '.xml')
      log.filename = Muvi2Generic.short_pathname(filename)
      file = File.new(filename, "wb")
      file.write(xml_return)
      file.close
      log.net_message = 'OK'
      success = true
    rescue Timeout::Error => e
      log.net_message = 'Timeout Error'
      success = false
    rescue
      log.net_message ='Other Error'
      success = false
    end
    if log.save
      {:log => log, :success => success}
    else
      {:log => nil, :success => false}
    end
  end

  def self.workflow_update
    trailers = Trailer.clarity_transfer_not_complete
    trailers.each do |trailer|
      self.workflow_update_individual(trailer)
    end
    house_numbers_text(trailers)
  end

  def self.workflow_update_individual(trailer)
    if trailer.diva_data && trailer.diva_data.job_id
      result = self.net_workflow_update(trailer.diva_data.job_id)
      Trailer.read_diva_workflow_data(trailer, false, result[:log])
    end
  end

  def self.net_workflow_update(workflow_id)
    log = DivaLog.new
    log.action = 'Workflow Update'
    settings = workflow_settings
    log.uri = settings[:uri] + workflow_id.to_s
    uri = URI(settings[:uri] + workflow_id.to_s)
    http = create_http(uri, settings[:timeout])
    req = Net::HTTP::Get.new(uri.request_uri)
    begin
      res = http.request(req)
      xml_return = res.body
      log.xml_received = xml_return
      filename = Rails.root.join('public','data', 'diva', 'workflow_status', workflow_id.to_s + '.xml')
      log.filename = Muvi2Generic.short_pathname(filename)
      file = File.new(filename, "wb")
      file.write(xml_return)
      file.close
      log.net_message = 'OK'
      success = true
    rescue Timeout::Error => e
      log.net_message = 'Timeout Error'
      success = false
    rescue
      log.net_message = 'Other Error'
      success = false
    end
    if log.save
      {:log => log, :success => success}
    else
      {:log => nil, :success => false}
    end
  end

private
  def self.media_search_settings
    media_search_uri = DivaSetting.find_by_name('Media Search URI')
    media_search_xml = DivaSetting.find_by_name('Media Search XML')
    net_timeout = DivaSetting.net_timeout_seconds
    {:uri => media_search_uri.value, :xml => media_search_xml.text_value, :timeout => net_timeout}
  end

  def self.workflow_settings
    workflow_uri = DivaSetting.find_by_name('Workflow URI')
    workflow_xml = DivaSetting.find_by_name('Workflow XML')
    net_timeout = DivaSetting.net_timeout_seconds
    {:uri => workflow_uri.value, :xml => workflow_xml.text_value, :timeout => net_timeout}
  end

  def self.create_http(uri, timeout)
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = timeout
    http.open_timeout = timeout
    http
  end

  def self.house_numbers_text(trailers)
    houses = ''
    trailers.each do |trailer|
      houses += trailer.house_number + ' '
    end
    houses.squish
  end
 
end