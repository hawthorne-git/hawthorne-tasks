require 'aws-sdk-s3'
require 'mini_magick'

# ---------------------------------------------- Establish a connection to AWS s2

s3 = Aws::S3::Client.new(
  region: 'us-east-2',
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
)

# ---------------------------------------------- List all buckets

resp = s3.list_buckets
puts resp.to_s

# ---------------------------------------------- Get a file

resp = s3.get_object(bucket: 'mapping-temp', key: 'test.jpeg')
puts resp.to_s

# ---------------------------------------------- Upload a file

aws_key = [*('a'..'z'), *('A'..'Z'), *('0'..'9')].shuffle[0, 25].join + '.jpeg'
aws_key = 'mapping_folder/' + aws_key
puts aws_key

image = MiniMagick::Image.open('C:\Users\hawth\RubymineProjects\hawthorne-tasks\AWS\test2.jpeg')

s3.put_object(
  bucket: 'mapping-temp',
  key: aws_key,
  body: StringIO.open(image.to_blob)
)

# ---------------------------------------------- Delete a file



# ----------------------------------------------