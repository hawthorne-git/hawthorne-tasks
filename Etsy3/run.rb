require 'json/ext'
require 'rest-client'

# ------------------------------------------------------------------------------------

api_keystring = 'api_keystring'

access_token = 'access_token'

# ------------------------------------------------------------------------------------

request_options_without_authorization = {
  'x-api-key': api_keystring
}

request_options_with_authorization = {
  'x-api-key': api_keystring,
  authorization: 'Bearer ' + access_token
}

# ------------------------------------------------------------------------------------

begin
  response = RestClient.get 'https://openapi.etsy.com/v3/application/listings/1315837451', headers = request_options_without_authorization
  puts response.body.to_s
rescue RestClient::ExceptionWithResponse => e
  puts 'EXCEPTION CAUGHT'
  puts e.message.to_s
  http_body = JSON.parse(e.http_body)
  puts http_body.to_s
end

# ------------------------------------------------------------------------------------