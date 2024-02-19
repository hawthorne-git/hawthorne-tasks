require 'uri'
require 'net/http'

url = URI("https://api.mediamodifier.com/v2/mockup/render")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Post.new(url)
request["api_key"] = 'secret'
request["Content-Type"] = 'application/json'
request["Accept"] = 'application/json'
    request.body = "{\n  \"nr\": 56370,\n  \"layer_inputs\": [\n    {\n      \"id\": \"f579b00b-9841-4d33-bcc7-d6dab6606998\",\n      \"data\": \"https://cl.imagineapi.dev/assets/428d764f-39a4-404f-9034-3c64dff431cb/428d764f-39a4-404f-9034-3c64dff431cb.png\",\n      \"crop\": {\n        \"x\": 0,\n        \"y\": 0,\n        \"width\": 647,\n        \"height\": 1400\n      },\n      \"checked\": true\n    },\n    {\n      \"id\": \"ea18e8f6-1e41-4a5e-bbe2-a469e2fea45d\",\n      \"checked\": true,\n      \"color\": {\n        \"red\": 254,\n        \"green\": 186,\n        \"blue\": 227\n      }\n    }\n  ]\n}"

response = http.request(request)
puts response.read_body