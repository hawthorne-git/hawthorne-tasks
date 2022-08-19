require 'oauth'
require 'rest-client'

api_key = '1'
api_secret = '2'
oauth_key = '3'
oauth_secret = '4'

consumer = OAuth::Consumer.new(
  api_key,
  api_secret,
  {
    site: 'https://openapi.etsy.com',
    request_token_path: '/v3/oauth/request_token?scope=',
    access_token_path: '/v3/oauth/access_token'
  }
)

access_token = OAuth::AccessToken.new(consumer, oauth_key, oauth_secret)

RestClient.add_before_execution_proc do |req, params|
  access_token.sign! req
end

puts 'done'

#response = RestClient.get 'https://openapi.etsy.com/v3/application/listings?state=active'
