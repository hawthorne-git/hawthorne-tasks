require 'uri'
require 'net/http'
require 'openssl'

url = URI("https://api.mediamodifier.com/mockups")
# "https://api.mediamodifier.com/mockups?page=1"


http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(url)
request["Content-Type"] = 'application/json'
request["api_key"] = ENV['api_key']

response = http.request(request)
puts response.read_body

