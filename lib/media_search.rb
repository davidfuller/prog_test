puts 'Media Search Runner'
house_number=ARGV[0]
# This routine requests info about a particular House number
require 'net/http'
uri = URI("http://10.254.21.27/api/media-search")
http = Net::HTTP.new(uri.host, uri.port)
req = Net::HTTP::Post.new(uri.path)
xml_string='<?xml version="1.0" encoding="UTF-8"?><search><parameters><param><name>miid2</name><value>!!house_number!!</value></param><param><name>storageDevice</name><valueList><value>DIVA_CG_CENT_MAIN</value><value>DIVA_CHISWICK_GREEN</value><value>DIVA_WEST_DRAYTON</value><value>WD_DIVA_MAIN</value><value>DIVA_CG_RIGA_NEPTUNE_INGESTED</value></valueList></param></parameters></search>'
xml_string.sub! '!!house_number!!', house_number
puts xml_string
req.body = xml_string
req.content_type = 'text/xml'
res = http.request(req)
xml_return = res.body
puts xml_return
filename = Rails.root.join('public','data', 'diva', 'search', house_number + '.xml')
file = File.new(filename, "wb")
file.write(xml_return)
file.close

