require 'json/ext'
require 'rest-client'

# ---------------------------------------------------------------------------

puts 'Starting ...'

# ---------------------------------------------------------------------------

get_lists = true

# ---------------------------------------------------------------------------

header = {
  Authorization: 'Bearer ' + ENV['BREVO_API_KEY'],
  content_type: :json
}

# ---------------------------------------------------------------------------

if get_lists

  url = 'https://api.brevo.com/v3/contacts/lists'

  puts header.to_s

  response = RestClient.get(url, header)

  puts response

end

# ---------------------------------------------------------------------------

puts 'Finished!'

# ---------------------------------------------------------------------------