require 'aws-sdk-rekognition'
require 'json/ext'

# ----------------------------------------------

AWS_IMAGE_KEY = 'swimwear_test.png'

#AWS_IMAGE_KEY = '12e871x5x3wbeh7ae8muvtfkqkna'

# ----------------------------------------------

client = Aws::Rekognition::Client.new(
  region: 'us-east-2',
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
)

# ----------------------------------------------

attrs = {
  image: {
    s3_object: {
      bucket: 'idesign-s3-bucket',
      name: AWS_IMAGE_KEY
    },
  },
  max_labels: 20
}

response = client.detect_labels attrs
puts response.to_s

response[:labels].each do |label|
  puts ''
  puts label.to_s
  puts label[:name]
end

# ----------------------------------------------

puts ''
puts ''

# ----------------------------------------------

attrs = {
  image: {
    s3_object: {
      bucket: 'idesign-s3-bucket',
      name: AWS_IMAGE_KEY
    },
  }
}

response = client.detect_moderation_labels attrs
puts response.to_s

# ----------------------------------------------