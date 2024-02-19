require 'uri'
require 'net/http'

url = URI("https://api.mediamodifier.com/mockups")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["api_key"] = 'secret'

response = http.request(request)
puts response.read_body