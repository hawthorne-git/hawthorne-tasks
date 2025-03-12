require 'json/ext'
require 'rest-client'

# ------------------------------------------------------------------------

GET_FOLDERS = false

GET_LISTS = false

CREATE_LIST = false

CREATE_CONTACT = true

# ------------------------------------------------------------------------

ACCESS_TOKEN = ENV['ACCESS_TOKEN']

AUTHORIZATION_HEADER = {
  api_key: ACCESS_TOKEN,
  content_type: :json
}

puts ACCESS_TOKEN

# ------------------------------------------------------------------------

# https://developers.brevo.com/reference/getfolders-1
if GET_FOLDERS

  url = 'https://api.brevo.com/v3/contacts/folders'

  response = RestClient.get(
    url,
    AUTHORIZATION_HEADER
  )

  puts response.to_s

end

# ------------------------------------------------------------------------

# https://developers.brevo.com/reference/getlists-1
if GET_LISTS

  url = 'https://api.brevo.com/v3/contacts/lists'

  response = RestClient.get(
    url,
    AUTHORIZATION_HEADER
  )

  puts response.to_s

end

# ------------------------------------------------------------------------

# https://developers.brevo.com/reference/createlist-1
if CREATE_LIST

  url = 'https://api.brevo.com/v3/contacts/lists'

  values = {
    folderId: 10,
    name: 'Newsletter'
  }

  response = RestClient.post(
    url,
    values.to_json,
    AUTHORIZATION_HEADER
  )

  puts response.to_s

end

# ------------------------------------------------------------------------

# https://developers.brevo.com/reference/createcontact
if CREATE_CONTACT

  url = 'https://api.brevo.com/v3/contacts'

  values = {
    updateEnabled: true,
    email: 'charlieprezzano@gmail.com'
  }

  response = RestClient.post(
    url,
    values.to_json,
    AUTHORIZATION_HEADER
  )

  puts response.to_s

end

# ------------------------------------------------------------------------


