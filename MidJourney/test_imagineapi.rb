require 'json/ext'
require 'rest-client'

# ------------------------------------------------------------------------

CREATE_IMAGE = false

SHOW_IMAGE = true

# ------------------------------------------------------------------------

PROMPT = 'clouds painted by monet'

TILED_PROMPT = PROMPT + ' --tile'

# ------------------------------------------------------------------------

IMAGE_ID = '27bf385c-f486-4a6c-ab97-1f0e5151f784'

# ------------------------------------------------------------------------

ACCESS_TOKEN = 'secret'

AUTHORIZATION_HEADER = {
  Authorization: 'Bearer ' + ACCESS_TOKEN,
  content_type: :json
}

# ------------------------------------------------------------------------

if CREATE_IMAGE

  url = 'https://cl.imagineapi.dev/items/images'

  values = { prompt: TILED_PROMPT }

  response = RestClient.post(
    url,
    values.to_json,
    AUTHORIZATION_HEADER
  )

  puts response.to_s

end

# ------------------------------------------------------------------------

if SHOW_IMAGE

  url = 'https://cl.imagineapi.dev/items/images/' + IMAGE_ID

  response = RestClient.get(
    url,
    AUTHORIZATION_HEADER
  )

  puts response.to_s

  puts JSON.parse(response)['data']['upscaled_urls']

end

# ------------------------------------------------------------------------