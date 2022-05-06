require 'uri'
require 'net/http'
require 'openssl'
require 'json/ext'
require 'rest-client'
require "open-uri"

ACCESS_TOKEN = ENV['DB_ACCESS_TOKEN']
DATA_CURSOR = ENV['DB_DATA_CURSOR']

api_arg = {
  "path": "/Homework/math/Matrices.txt",
  "mode": "add",
  "autorename": true,
  "mute": false,
  "strict_conflict": false
}.to_json


AUTHORIZATION_HEADER = {
  Authorization: 'Bearer ' + ACCESS_TOKEN,
  'content-type': :json,
  'Dropbox-Api-Path-Root': {".tag":'namespace_id', "namespace_id": '6653412160'}.to_json,
  #'Dropbox-API-Arg': api_arg
}

values = {
  path: '/for nick/fabric to test/_wooden_background.png'
}

dropbox_image_path = "/dropbox_images"

response = RestClient.post('https://api.dropboxapi.com/2/files/get_temporary_link', values.to_json, AUTHORIZATION_HEADER)
=begin
puts response.body
JSON.parse(response).each do |resp|
  puts resp
end
=end

dropbox_response = JSON.parse(response)['link']

open('dropbox_images/image.png', 'wb') do |file|
  file << URI.open(dropbox_response).read
end

# -------------------------------------------------------- Shared folders path (working..)
=begin
AUTHORIZATION_HEADER = {
  Authorization: 'Bearer ' + ACCESS_TOKEN,
  'content-type': :json,
  'Dropbox-Api-Path-Root': {".tag":'namespace_id', "namespace_id": '6653412160'}.to_json
}

values = {
  path: '/for nick/fabric to test/'
}
response = RestClient.post('https://api.dropboxapi.com/2/files/list_folder', values.to_json, AUTHORIZATION_HEADER)
puts response.body
JSON.parse(response).each do |resp|
  puts resp
end
=end


# -------------------------------------------------------------------------looking at the response body

=begin
begin
 RestClient.post('https://api.dropboxapi.com/2/files/list_folder', values.to_json, AUTHORIZATION_HEADER)
rescue RestClient::ExceptionWithResponse => e
  puts e.response
end
=end
=begin
url = URI('https://api.dropboxapi.com/2/files/list_folder')

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(url)
request['Content-Type'] = 'application/json'
request['Authorization'] = 'Bearer ' + ACCESS_TOKEN
request['Dropbox-Api-Path-Root'] = {".tag":"namespace_id", "namespace_id": "6653412160"}
request['path'] = ''

response = http.request(request)
puts response.read_body
=end

# {".tag"=>"folder", "name"=>"Indy Bloom Design Hawthorne", "path_lower"=>"/indy bloom design hawthorne", "path_display"=>"/Indy Bloom Design Hawthorne", "id"=>"id:gi9wT67UmPAAAAAAAAACFQ", "shared_folder_id"=>"2187772433", "sharing_info"=>{"read_only"=>false, "shared_folder_id"=>"2187772433", "traverse_only"=>false, "no_access"=>false}

# -------------------------------------------------------- List of Shared Folders (working..) (69 files and folders)
=begin

values = {
  "limit": 100,
  "actions": []
}

response = RestClient.post('https://api.dropboxapi.com/2/sharing/list_folders', values.to_json, AUTHORIZATION_HEADER)

JSON.parse(response).each do |resp|
  puts resp
  # 11 = Digital Printing Production "shared_folder_id"=>"6653412480"
  # 18 = Digital Printing Design "shared_folder_id"=>"6653412160"
end
=end

# --------------------------------------------------------------------------------------- List Folder continue (working)

=begin

values = {
  cursor: DATA_CURSOR
}

response = RestClient.post('https://api.dropboxapi.com/2/files/list_folder/continue', values.to_json, AUTHORIZATION_HEADER)

JSON.parse(response).each do |resp|
  puts resp
end

=end

#{"access_type"=>{".tag"=>"editor"}, "is_inside_team_folder"=>true, "is_team_folder"=>false, "owner_team"=>{"id"=>"dbtid:AAAc2rC5W-aNrSCuE2jSKOJ1oxcyeF3s5Go", "name"=>"Hawthorne"}, "parent_folder_name"=>"Independent Designer Marketing", "name"=>"Emily Landrum Design Transfer Folder", "policy"=>{"member_policy"=>{".tag"=>"anyone"}, "resolved_member_policy"=>{".tag"=>"anyone"}, "acl_update_policy"=>{".tag"=>"editors"}, "shared_link_policy"=>{".tag"=>"anyone"}, "viewer_info_policy"=>{".tag"=>"enabled"}}, "preview_url"=>"https://www.dropbox.com/scl/fo/76gajf08q5ijrlstr6fz9/AAA7CppKqbJYSH11xcZCZd8Aa?dl=0", "shared_folder_id"=>"9265539296", "time_invited"=>"2021-03-10T22:26:07Z", "access_inheritance"=>{".tag"=>"inherit"}}


def organize_shared_folders(aresponse)
  JSON.parse(aresponse).each do |resp|
    count = 1
    resp[1].each do |r|
      if r['parent_folder_name'].nil? || r['parent_folder_name'].empty?
        puts "#{count}:  NAME: #{r['name']},\n     SHARED_FOLDER_ID: #{r['shared_folder_id']}"
      else
        puts "#{count}:  PARENT_FOLDER_NAME: #{r['parent_folder_name']},\n     NAME: #{r['name']},\n     SHARED_FOLDER_ID: #{r['shared_folder_id']}"
      end
      count += 1
    end
  end
end

