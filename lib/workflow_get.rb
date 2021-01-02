puts 'Workflow Get Runner'
workflow_id=ARGV[0]
# This routine Runs the workflow for a give system id
require 'net/http'
uri = URI("http://10.254.21.27/api/workflow/" + workflow_id)
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)
xml_return = response.body
puts xml_return
filename = Rails.root.join('public','data', 'diva', 'workflow_status', workflow_id + '.xml')
file = File.new(filename, "wb")
file.write(xml_return)
file.close