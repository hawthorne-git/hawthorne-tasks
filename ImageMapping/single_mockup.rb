require 'uri'
require 'net/http'
require 'openssl'
def el_nr

  "520"
end

url = URI("https://api.mediamodifier.com/mockup/nr/#{el_nr}")

puts url


http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(url)
request["Content-Type"] = 'application/json'
request["api_key"] = ENV['api_key']

response = http.request(request)
single = eval(response.body)    #single is a Hash

# puts single
#puts single[:mockup].each_key {|key| puts key }

#puts single[:mockup][:layers].each_entry {|key| puts key }

#layers = single[:mockup][:layers]  #layers is an Array

#puts layers[0][:placeholder]

#puts layers.each_entry {|key| puts key }

#nr = single[:mockup][:nr]


def open_mockup(mock)
  mockup_array = [mock[:mockup][:nr]]
  layers = mock[:mockup][:layers]

  layers.each { |i|
    mockup_array.push(i[:id])
    mockup_array.push(i[:placeholder])
  }

  mockup_array.compact!
end

# puts "#{open_mockup(single)}"

# figure_it_out = "{\n  \"nr\": 6323,\n  \"layer_inputs\": [\n    {\n      \"id\": \"f579b00b-9841-4d33-bcc7-d6dab6606998\",\n      \"data\": \"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAocA...\",\n      \"crop\": {\n        \"x\": 0,\n        \"y\": 0,\n        \"width\": 647,\n        \"height\": 1400\n      },\n      \"checked\": true\n    },\n    {\n      \"id\": \"ea18e8f6-1e41-4a5e-bbe2-a469e2fea45d\",\n      \"checked\": true,\n      \"color\": {\n        \"red\": 254,\n        \"green\": 186,\n        \"blue\": 227\n      }\n    }\n  ]\n}"
def puts_in_array(arr)
  image_goes_here = ":)"
  figured = "{\n  \"nr\": #{arr[0]},\n  \"layer_inputs\": [\n    {\n      \"id\": \"#{arr[1]}\",\n      \"data\": \"data:image/png;base64,#{image_goes_here}\",\n      \"crop\": {\n        \"x\": 0,\n        \"y\": 0,\n        \"width\": #{arr[2][:width]},\n        \"height\": #{arr[2][:height]}\n      },\n      \"checked\": true\n    },\n    {\n      \"id\": \"#{arr[3]}\",\n      \"checked\": true,\n      \"color\": {\n        \"red\": 254,\n        \"green\": 186,\n        \"blue\": 227\n      }\n    }\n  ]\n}"


  if arr.length == 4
    puts "It's Four #{arr.length}"
  elsif arr.length == 5
    puts "It's Five don't know what to do"
  else
    puts "I went too far"
  end
  puts figured
end


#puts_in_array(open_mockup(single))