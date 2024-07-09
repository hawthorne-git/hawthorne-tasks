require 'json/ext'
require 'rest-client'

# ---------------------------------------------------------------------------

puts 'Starting ...'

# ---------------------------------------------------------------------------

get_user_info = true

# ---------------------------------------------------------------------------

header = {
  Authorization: 'Bearer ' + 'a63919ea-3e99-4242-8aff-8cb260b58574',
  content_type: :json
}

# ---------------------------------------------------------------------------

if get_user_info

  url = 'https://cloud.leonardo.ai/api/rest/v1/me'

  response = RestClient.get(url, header)

  puts response.to_s

end