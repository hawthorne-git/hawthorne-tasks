require 'midjourney'

# ------------------------------------------------------------------------

api_key = 'secret'

# ------------------------------------------------------------------------

if true

  Midjourney.configure do |config|
    config.access_token = api_key
  end

  client = Midjourney::Client.new

  response = client.imagine(
    parameters: {
      prompt: 'A stunning forest beneath a bright blue sky'
    }
  )

  puts response["taskId"]
  puts response['taskId']
  puts response[:taskId]

end

# ------------------------------------------------------------------------

if false

  client = Midjourney::Client.new(
    access_token: api_key,
    request_timeout: 240
  )

  response = client.imagine(
    parameters: {
      prompt: 'A stunning forest beneath a bright blue sky'
    }
  )

  puts response["taskId"]
  puts response['taskId']
  puts response[:taskId]

end

# ------------------------------------------------------------------------