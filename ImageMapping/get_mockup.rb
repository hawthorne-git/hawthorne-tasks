
require 'uri'
require 'net/http'
require 'openssl'

#url = URI("https://api.mediamodifier.com/mockup/nr/nr")

url = URI("https://api.mediamodifier.com/mockup/nr/7944")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(url)
request["Content-Type"] = 'application/json'
request["api_key"] = ENV['api_key']

response = http.request(request)
puts response.read_body