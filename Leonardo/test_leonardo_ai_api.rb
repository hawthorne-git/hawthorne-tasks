require 'json/ext'
require 'rest-client'

# ---------------------------------------------------------------------------

puts 'Starting ...'

# ---------------------------------------------------------------------------

get_user_info = false

create_image = false

# ---------------------------------------------------------------------------

header = {
  Authorization: 'Bearer ' + ENV['LEONARDO_TOKEN'],
  content_type: :json
}

# Fetch generationID method for getting images ------------------------------

def fetch_generation_details(generation_id)
  url = "https://cloud.leonardo.ai/api/rest/v1/generations/#{generation_id}"

  headers = {
    accept: 'application/json',
    Authorization: "Bearer #{ENV['LEONARDO_TOKEN']}"
  }

  begin

    response = RestClient.get(url, headers)

    puts "Response code: #{response.code}"
    puts "Response body: #{response.body}"

  end
end

# ---------------------------------------------------------------------------

if get_user_info

  url = 'https://cloud.leonardo.ai/api/rest/v1/me'

  response = RestClient.get(url, header)

  puts response.to_s

end

# ---------------------------------------------------------------------------

if create_image
  url = 'https://cloud.leonardo.ai/api/rest/v1/generations'

  values = {
    "height": 512,
    "width": 512,
    "modelId": "b24e16ff-06e3-43eb-8d33-4416c2d75876",
    "prompt": "mountains painted by monet",
    "num_images": 1
  }

  begin
    response = RestClient.post(
      url,
      values.to_json,
      header
    )

    # Parse JSON response
    parsed_response = JSON.parse(response.body)

    # Extract generation ID and API Credit Cost from sdGenerationJob
    generation_id = parsed_response['sdGenerationJob']['generationId']
    api_credit_cost = parsed_response['sdGenerationJob']['apiCreditCost']

    # Now use this generation ID to fetch details of this specific generation
    fetch_generation_details(generation_id)

    puts "Generation ID: #{generation_id}"
    puts "API Credit Cost: #{api_credit_cost}"
    puts "Response body:#{response.body}"

  end

end

