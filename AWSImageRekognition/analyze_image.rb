require 'aws-sdk-rekognition'

# ---------------------------------------------- Establish a connection to AWS s2
# https://docs.aws.amazon.com/rekognition/latest/dg/labels-detect-labels-image.html
# https://docs.aws.amazon.com/rekognition/latest/dg/procedure-moderate-images.html

client = Aws::Rekognition::Client.new(
  region: 'us-east-2',
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
)

attrs = {
  image: {
    s3_object: {
      bucket: 'idesign-s3-bucket',
      name: '086klwrecq1e3urtphkmjetvox0w'
    },
  },
  max_labels: 10
}

response = client.detect_labels attrs

puts response.to_s

# ----------------------------------------------