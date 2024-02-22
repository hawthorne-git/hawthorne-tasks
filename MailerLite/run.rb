require 'json/ext'
require 'mailerlite-ruby'

# get a grounp - welcome email
groups = MailerLite::Groups.new
response = groups.get_subscribers(group_id:113094917732959433, page:1, limit:10, filter:{'status': 'active'})
puts response.to_s

# assign a user to a group
groups = MailerLite::Groups.new
response = groups.assign_subscriber(subscriber:113711779055404510, group_id:113094917732959433)
puts response.to_s

return if true


# list all groups
groups = MailerLite::Groups.new
response = groups.list(limit:10, page:1, filter:{}, sort:'name')
puts response.to_s #NOT WORKING



# list all automations
automations = MailerLite::Automations.new
response = automations.get(limit:10, page:1, filter:{})
puts response.to_s

puts ''
puts ''

# list the welcome automation
automations = MailerLite::Automations.new
automation_id = '113093993045165264'
response = automations.fetch(automation_id)
puts response.to_s

puts ''
puts ''


# delete a subscriber
subscribers = MailerLite::Subscribers.new
subscriber_id = 113711779055404510
subscribers.delete(subscriber_id)

puts ''
puts ''

# list all subscribers
subscribers = MailerLite::Subscribers.new
response = subscribers.fetch(filter: { status: 'active' })
puts response.to_s
puts JSON.parse(response)['data'].size.to_s

puts ''
puts ''


# create a subscriber
  subscribers = MailerLite::Subscribers.new
  response = subscribers.create(email:'charlieprezzano@gmail.com', fields: {}, ip_address:'1.2.3.4', optin_ip:'1.2.3.4')
  puts response.to_s
  subscriber_id = JSON.parse(response)['data']['id'].to_s
  puts subscriber_id


puts ''
puts ''


# list all subscribers
subscribers = MailerLite::Subscribers.new
response = subscribers.fetch(filter: { status: 'active' })
puts response.to_s
puts JSON.parse(response)['data'].size.to_s

puts ''
puts ''

