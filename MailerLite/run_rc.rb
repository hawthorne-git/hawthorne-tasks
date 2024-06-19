require 'json/ext'
require 'rest-client'

# ------------------------------------------------------------------

get_all_groups = false

subscribe_a_user = false

is_user_subscribed = false

get_subscriber_id = true

subscribe_to_group = false

# ------------------------------------------------------------------

authorization_header = {
  authorization: 'Bearer ' + ENV['MAILERLITE_API_TOKEN'],
  content_type: :json,
  accept: :json
}

# ------------------------------------------------------------------ get all groups

if get_all_groups

  api_url = 'https://connect.mailerlite.com/api/groups'

  response = RestClient.get api_url, authorization_header

  puts response.to_s

end

# ------------------------------------------------------------------ subscribe a user

if subscribe_a_user

  email_address = 'hawthorne.purchases@gmail.com'

  api_url = 'https://connect.mailerlite.com/api/subscribers'

  values = { email: email_address }

  RestClient.post api_url, values.to_json, authorization_header

end

# ------------------------------------------------------------------ is a user subscribed?

if is_user_subscribed

  email_address = 'charlieprezzano@gmail.com'

  api_url = 'https://connect.mailerlite.com/api/subscribers/' + email_address

  begin
    response = RestClient.get api_url, authorization_header
    puts 'subscribed' if response.code == 200
  rescue RestClient::Exception
    puts 'not subscribed'
  end

  # puts response.code

end

# ------------------------------------------------------------------ get subscriber id

if get_subscriber_id

  email_address = 'charlieprezzano@gmail.com1'

  api_url = 'https://connect.mailerlite.com/api/subscribers/' + email_address

  response = RestClient.get api_url, authorization_header

  puts JSON.parse(response)['data']['id'].to_s

end

# ------------------------------------------------------------------ subscribe to group

if subscribe_to_group

  group_id = '113094917732959433'

  subscriber_id = '113711779055404510'

  api_url = 'https://connect.mailerlite.com/api/subscribers/' + subscriber_id + '/groups/' + group_id

  RestClient.post api_url, {}.to_json, authorization_header

end

# ------------------------------------------------------------------
