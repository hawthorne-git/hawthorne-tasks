require 'uri'
require 'net/http'
require 'openssl'
require "base64"

#image dimensions' has to bee big enough
el_width = "5000"

el_height = "5000"

base64_image =
  File.open("C:/Users/hawth/Desktop/flower.png", "rb") do |file|
    Base64.strict_encode64(file.read)
  end


url = URI("https://api.mediamodifier.com/mockup/render")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Post.new(url)
request["Content-Type"] = 'application/json'
request["api_key"] = ENV['api_key']

#request.body = "{\n  \"nr\": 520,\n  \"layer_inputs\": [\n    {\n      \"id\": \"juqu6evm8k4dtcu835p\",\n      \"data\": \"data:image/png;base64,#{base64_image}\",\n      \"crop\": {\n        \"x\": 0,\n        \"y\": 0,\n        \"width\": 293,\n        \"height\": 292\n      },\n      \"checked\": true\n    },\n    {\n      \"id\": \"juqu6evngbz3cjyh7sj\",\n      \"checked\": true,\n      \"color\": {\n        \"red\": 255,\n        \"green\": 128,\n        \"blue\": 0\n      }\n    }\n  ]\n}"


#request.body = "{\n  \"nr\": 520,\n  \"layer_inputs\": [\n    {\n      \"id\": \"juqu6evm8k4dtcu835p\",\n      \"data\": \"data:image/png;base64,#{base64_image}\",\n      \"crop\": {\n        \"x\": 0,\n        \"y\": 0,\n        \"width\": 1172,\n        \"height\": 1168\n      },\n      \"checked\": true\n    },\n    {\n      \"id\": \"juqu6evngbz3cjyh7sj\",\n      \"checked\": true,\n      \"color\": {\n        \"red\": 255,\n        \"green\": 128,\n        \"blue\": 0\n      }\n    }\n  ]\n}"
# for the iphone print request.body = "{\n  \"nr\": 964,\n  \"layer_inputs\": [\n    {\n      \"id\": \"juzmnf5itk2mihxh8im\",\n      \"data\": \"data:image/png;base64,#{base64_image}\",\n      \"crop\": {\n        \"x\": 0,\n        \"y\": 0,\n        \"width\": 497,\n        \"height\": 1076\n      },\n      \"checked\": true\n    },\n    {\n      \"id\": \"juzmnf5jgfairynbi1t\",\n      \"checked\": true,\n      \"color\": {\n        \"red\": 255,\n        \"green\": 128,\n        \"blue\": 0\n      }\n    }\n  ]\n}"

request.body = "{\n  \"nr\": 54224,\n  \"layer_inputs\": [\n    {\n      \"id\": \"8c4f0a65-3589-4f47-b0b2-6758851c7102\",\n      \"data\": \"data:image/png;base64,#{base64_image}\",\n      \"crop\": {\n        \"x\": 0,\n        \"y\": 0,\n        \"width\": #{el_width},\n        \"height\": #{el_height}\n      },\n      \"checked\": true\n    },\n    {\n      \"id\": \"31fccb0c-1d21-4190-8dc8-711962e93199\",\n      \"checked\": true,\n      \"color\": {\n        \"red\": 224,\n        \"green\": 219,\n        \"blue\": 213\n      }\n    }\n  ]\n}"
#\"width\": 359,\n        \"height\": 319\n

response = http.request(request)
puts response.body

