require 'uri'
require 'net/http'
require 'openssl'
require "base64"
require "mini_magick"

fabric = "autumn"
tiles = 4

img_path = "Tiles/tile#{fabric}x#{tiles}.png"
img = MiniMagick::Image.open(img_path)


el_width = img.dimensions[0]
el_height = img.dimensions[1]

base64_image =
  File.open(img_path, "rb") do |file|
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
finalproject = response.body

# puts finalproject[88..-3]


mockupfinished = finalproject[88..-3]

# puts mockupfinished

img_from_base64 = Base64.decode64(mockupfinished)
# => "\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\xAA\x00\x00\x00\xAA\b\x06\x00\x00\x00=v\xD4\x82\x00\x00\x00IDATx\x9C\xEC\xBDi\x98%Wy\xE7\xF9;[D\xDC-3++k\xDF\xF7U\xA2T\x92J*\xAD\xA5}A`\ff\xB1\xB11\ ..."

# cut the data where it seems to hold the filetype
img_from_base64[0,8]
# => "\x89PNG\r\n\x1A\n"

# find file type
filetype = /(png|jpg|jpeg|gif|PNG|JPG|JPEG|GIF)/.match(img_from_base64[0,16])[0]
# name the file
filename = "mockup#{fabric}#{el_width}x#{el_height}"

# write file
file = filename << '.' << filetype
File.open(file, 'wb') do|f|
 f.write(img_from_base64)
end
