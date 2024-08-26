require 'json/ext'
require 'rest-client'

# ---------------------------------------------------------------------------

puts 'Starting ...'

# ---------------------------------------------------------------------------

account_info = true

create_image = false

get_progress = false


# ---------------------------------------------------------------------------

header = {
  Authorization: 'Bearer ' + ENV['API_FRAME_API_TOKEN'],
  content_type: :json
}

# ---------------------------------------------------------------------------

if account_info

  url = 'https://api.apiframe.pro/account'

  response = RestClient.get(
    url,
    header
  )

  puts response.to_s

end

# ---------------------------------------------------------------------------

if create_image

  url = 'https://api.apiframe.pro/imagine'

  values = {
    prompt: 'monet flowers in retro colors --tile --v 6'
  }

  response = RestClient.post(
    url,
    values.to_json,
    header
  )

  puts response.to_s

end

# ---------------------------------------------------------------------------

if get_progress

  url = 'https://api.apiframe.pro/fetch'

  values = {
    task_id: '822aa1b1-f058-4f47-906b-de4fca62fae3'
  }

  response = RestClient.post(
    url,
    values.to_json,
    header
  )

  puts response.to_s

end

# ---------------------------------------------------------------------------

puts 'Finished!'

# ---------------------------------------------------------------------------