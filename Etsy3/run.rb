require 'json/ext'
require 'rest-client'

# ------------------------------------------------------------------------------------

api_keystring = 'htz.....'

access_token = '626126701...'

# ------------------------------------------------------------------------------------

request_options_without_authorization = {
  'x-api-key': api_keystring
}

request_options_with_authorization = {
  'x-api-key': api_keystring,
  authorization: 'Bearer ' + access_token
}

# ------------------------------------------------------------------------------------

uri = URI('https://openapi.etsy.com/v3/application/listings/1206223359')
req = Net::HTTP::Get.new(uri)
req['x-api-key'] = api_keystring

res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http|
  http.request(req)
}

#puts res.body.to_s

# ------------------------------------------------------------------------------------

uri = URI('https://openapi.etsy.com/v3/application/shops/35063660/transactions')
req = Net::HTTP::Get.new(uri)
req['x-api-key'] = api_keystring
req['authorization'] = 'Bearer ' + access_token

res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http|
  http.request(req)
}

#puts res.body.to_s

# ------------------------------------------------------------------------------------

begin
  #response = RestClient.get 'https://openapi.etsy.com/v3/application/listings/1301252552', headers = request_options_with_authorization
  #puts response.body.to_s
rescue RestClient::Unauthorized => e
  puts e.message.to_s
end

# ------------------------------------------------------------------------------------

begin
  response = RestClient.get 'https://openapi.etsy.com/v3/application/shops/35063660/sections', headers = request_options_with_authorization
  #puts response.body.to_s
rescue RestClient::NotFound => e
  puts e.message.to_s
end

# ------------------------------------------------------------------------------------

puts ''

begin
  response = RestClient.get 'https://openapi.etsy.com/v3/application/shops/35063660/listings/1301271444/properties', headers = request_options_with_authorization
  puts response.body.to_s
rescue RestClient::ExceptionWithResponse => e
  puts 'EXCEPTION CAUGHT'
  puts e.message.to_s
  http_body = JSON.parse(e.http_body)
  puts http_body.to_s
end

# ------------------------------------------------------------------------------------