require 'aws-sdk-s3'

puts 'here in add file'


s3 = Aws::S3::Client.new(
  region: 'us-east-2',
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
)

bucket = s3.bucket('idesign-s3-bucket')

puts bucket.to_s