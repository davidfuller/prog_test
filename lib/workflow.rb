puts 'Workflow Runner'
system_id=ARGV[0]
# This routine Runs the workflow for a give system id
require 'net/http'
uri = URI("http://10.254.21.27/api/workflow/")
http = Net::HTTP.new(uri.host, uri.port)
req = Net::HTTP::Post.new(uri.path)
xml_string='<?xml version="1.0" encoding="UTF-8"?><job xmlns="http://www.tmd.tv/schema/MediaflexAPI/job-post" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.tmd.tv/schema/MediaflexAPI/job-post postJob.xsd"><presetName>Miguel_Restore_promo_to_MuVi2</presetName><sourceItems><sourceItem>media/id:!!system_id!!</sourceItem></sourceItems></job>'
xml_string.sub! '!!system_id!!', system_id
puts xml_string
req.body = xml_string
req.content_type = 'text/xml'
res = http.request(req)
xml_return = res.body
puts xml_return
filename = Rails.root.join('public','data', 'diva', 'workflow', system_id + '.xml')
file = File.new(filename, "wb")
file.write(xml_return)
file.close

