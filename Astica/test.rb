require 'json/ext'
require 'rest-client'

# ------------------------------------------------------------------------

image_url = 'https://cl.imagineapi.dev/assets/e6186f62-a5b3-4fac-b47b-6995122d9d86/e6186f62-a5b3-4fac-b47b-6995122d9d86.png'

vision_params = 'describe,describe_all,gpt,moderate,landmarks,tags,brands'
vision_params = 'describe,describe_all,tags'

# ------------------------------------------------------------------------

TOKEN = 'secret'

MODEL_VERSION = '2.1_full'

HEADER = {
  content_type: :json
}

# ------------------------------------------------------------------------

url = 'https://vision.astica.ai/describe'

values = {
  tkn: TOKEN,
  modelVersion: MODEL_VERSION,
  visionParams: vision_params,
  input: image_url
}

response = RestClient::Request.execute(:method => :post, :url => url, :payload => values.to_json, :headers => HEADER, :timeout => 90000000)

response = RestClient.post(
  url,
  values.to_json,
  HEADER,
) if false

puts response.to_s

# ------------------------------------------------------------------------