require 'json/ext'
require 'rest-client'

# ----------------------------------------------------------------------

ACCESS_TOKEN = ENV['DROPBOX_ACCESS_TOKEN']

AUTHORIZATION_HEADER = {
  Authorization: 'Bearer ' + ACCESS_TOKEN,
  content_type: :json
}

# ---------------------------------------------------------------------- List folder (Working ...)

values = {
  path: '',
  recursive: true
}

response = RestClient.post('https://api.dropboxapi.com/2/files/list_folder', values.to_json, AUTHORIZATION_HEADER)

JSON.parse(response).each do |resp|
  puts resp.to_s
end
puts ''

# ---------------------------------------------------------------------- List Revisions of a file, where the file is owned by the user (Working ...)

values = {
  path: '/Screenshots/Screenshot 2020-04-24 17.03.49.png',
  mode: 'path',
  limit: 10
}

response = RestClient.post('https://api.dropboxapi.com/2/files/list_revisions', values.to_json, AUTHORIZATION_HEADER)

JSON.parse(response).each do |resp|
  puts resp.to_s
end
puts ''

# ---------------------------------------------------------------------- List Revisions of a file, where the file is NOT owned by the user (NOT Working ...)

values = {
  path: '../HawthorneAdminLink.txt',
  mode: 'path',
  limit: 10
}

response = RestClient.post('https://api.dropboxapi.com/2/files/list_revisions', values.to_json, AUTHORIZATION_HEADER)

JSON.parse(response).each do |resp|
  puts resp.to_s
end
puts ''

# ----------------------------------------------------------------------

puts 'Done'