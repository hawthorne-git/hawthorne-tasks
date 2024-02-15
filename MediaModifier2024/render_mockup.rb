require 'json/ext'
require 'rest-client'

# --------------------------------------------------------------------

MOCKUP_NBR = 148261

MAPPED_IMAGE_WIDTH_IN_PIXELS = 1350

MAPPED_IMAGE_HEIGHT_IN_PIXELS = 1350

# --------------------------------------------------------------------

API_URL = 'https://api.mediamodifier.com/v2/mockup/render'

AUTHORIZATION_HEADER = {
  'Content-Type' => :json,
  'api_key' => ENV['mm_api_key']
}

# --------------------------------------------------------------------

values = {
  'nr': MOCKUP_NBR,
  'layer_inputs': [
    {
      'id': '9c176e57-e96c-47a3-ad8b-8607ba9b1c16',
      'data': 'https://cl.imagineapi.dev/assets/e4ad7b67-842c-4188-9c97-0bee5ac4a847/e4ad7b67-842c-4188-9c97-0bee5ac4a847.png',
      'crop': {
        'x': 0,
        'y': 0,
        'width': MAPPED_IMAGE_WIDTH_IN_PIXELS,
        'height': MAPPED_IMAGE_HEIGHT_IN_PIXELS
      },
      'checked': true
    }
  ]
}

response = RestClient.post API_URL, values.to_json, AUTHORIZATION_HEADER
puts response.to_s

# --------------------------------------------------------------------