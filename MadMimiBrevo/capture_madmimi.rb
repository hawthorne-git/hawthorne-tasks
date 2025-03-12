require 'csv'

csv = CSV.read('C:\Users\ht-ruby\RubymineProjects\hawthorne-tasks\MadMimiBrevo\madmimi.csv')

csv.first(5).each_with_index do |contact, index|

  next if index.zero?

  contact_nbr = contact[0]
  email_address = contact[1]
  created_at = contact[2]
  updated_at = contact[3]
  suppressed = (contact[4] == 'TRUE')
  suppressed_reason = contact[5]&.upcase

  puts ''
  puts contact_nbr
  puts email_address
  puts created_at
  puts updated_at
  puts suppressed.to_s
  puts suppressed_reason

end

