require 'json/ext'
require 'rest-client'

# ---------------------------------------------------------------------------

puts 'Starting ...'

# ---------------------------------------------------------------------------

create_image = false

create_image_sref = false

get_progress = true

do_upscale = false

do_upscale_4x = false

do_variation = false

# ---------------------------------------------------------------------------

header = {
  Authorization: 'Bearer ' + ENV['MY_MIDJOURNEY_API_TOKEN'],
  content_type: :json
}

# ---------------------------------------------------------------------------

if create_image

  url = 'https://api.mymidjourney.ai/api/v1/midjourney/imagine'

  values = {
    prompt: 'monet flowers in retro colors --tile --v 6',
    ref: 'charlie-p',
    webhookOverride: 'https://www.idesignmarketplace.com/webhook/mymidjourney-ai/LaoEzmyA7a'
  }

  response = RestClient.post(
    url,
    values.to_json,
    header
  )

  puts response.to_s

end

# ---------------------------------------------------------------------------

if create_image_sref

  url = 'https://api.mymidjourney.ai/api/v1/midjourney/imagine'

  values = {
    prompt: 'floral and bird design --tile --sref https://cdn.sandersondesigngroup.com/processed-images/products/large/DM5F226591.jpg --v 6'
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

  message_id = '694302f0-0b55-469d-8786-953b5e4ac367'

  url = 'https://api.mymidjourney.ai/api/v1/midjourney/message/' + message_id

  response = RestClient.get(
    url,
    header
  )

  puts response.to_s

end

# ---------------------------------------------------------------------------

if do_upscale

  url = 'https://api.mymidjourney.ai/api/v1/midjourney/button'

  values = {
    messageId: '36632d32-e78f-4f38-b6af-a117753de71f',
    button: 'U3'
  }

  response = RestClient.post(
    url,
    values.to_json,
    header
  )

  puts response.to_s

end

# ---------------------------------------------------------------------------

if do_upscale_4x

  url = 'https://api.mymidjourney.ai/api/v1/midjourney/button'

  values = {
    messageId: '832681f0-613a-4156-8930-24c2a7ad8806',
    button: 'Upscale (4x)'
  }

  response = RestClient.post(
    url,
    values.to_json,
    header
  )

  puts response.to_s

end

# ---------------------------------------------------------------------------

if do_variation

  url = 'https://api.mymidjourney.ai/api/v1/midjourney/button'

  values = {
    messageId: '832681f0-613a-4156-8930-24c2a7ad8806',
    button: 'Vary (Subtle)'
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