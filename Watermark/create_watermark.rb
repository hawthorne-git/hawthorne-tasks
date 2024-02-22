require 'mini_magick'

image_url = 'https://idesign-s3-bucket.s3.us-east-2.amazonaws.com/eea8zq27ja49id1r0fxw4xye64l7'
watermark_url = 'https://idesign-s3-bucket.s3.us-east-2.amazonaws.com/static/watermark.png'

image = MiniMagick::Image.open(image_url)
puts 'image_size: ' + (image['%[size]'].to_f / 1024 / 1024).to_s + 'MB'

watermark = MiniMagick::Image.open(watermark_url)
puts 'watermark_size: ' + (watermark['%[size]'].to_f / 1024 / 1024).to_s + 'MB'

image_height = image['%[height]'].to_i
image_width = image['%[width]'].to_i

watermark_resize_height = image_height / 2
watermark_resize_width = image_width / 2

watermark.resize(watermark_resize_width.to_s + 'x' + watermark_resize_height.to_s)

result = image.composite(watermark) do |c|
  c.compose 'Over'
  c.gravity 'center'
end
result.write 'output.jpg'