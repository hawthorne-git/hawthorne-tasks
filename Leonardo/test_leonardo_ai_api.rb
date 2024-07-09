require 'json/ext'
require 'rest-client'

# ---------------------------------------------------------------------------

puts 'Starting ...'

# ---------------------------------------------------------------------------

get_user_info = true

# ---------------------------------------------------------------------------

header = {
  Authorization: 'Bearer ' + ENV['LEONARDO_TOKEN'],
  content_type: :json
}

# ---------------------------------------------------------------------------

if get_user_info

  url = 'https://cloud.leonardo.ai/api/rest/v1/me'

  response = RestClient.get(url, header)

  puts response.to_s

end