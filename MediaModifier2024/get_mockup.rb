require 'rest-client'

-----------------------------------------------------------------

MOCKUP_NBR = 155867

API_URL = 'https://api.mediamodifier.com/mockup/nr/' + MOCKUP_NBR.to_s

AUTHORIZATION_HEADER = {
  'Content-Type' => :json,
  'api_key' => ENV['mm_api_key']
}

response = RestClient.get API_URL, AUTHORIZATION_HEADER

puts response.to_s

# --------------------------------------------------------------------