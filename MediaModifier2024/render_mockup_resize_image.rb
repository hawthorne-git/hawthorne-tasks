require 'base64'
require 'json/ext'
require 'mini_magick'
require 'rest-client'

# -------------------------------------------------------------------- Constants ... ADD IN SCALE - CUSTOMER COULD SAY THEY WANT THIS AT 50%

API_URL = 'https://api.mediamodifier.com/v2/mockup/render'

AUTHORIZATION_HEADER = {
  'Content-Type' => :json,
  'api_key' => ENV['mm_api_key']
}

MOCKUP_NBR = 148261
MAPPED_IMAGE_WIDTH_IN_PIXELS = 1350
MAPPED_IMAGE_HEIGHT_IN_PIXELS = 1350
MAPPED_IMAGE_WIDTH_IN_INCHES = 50.0
MAPPED_IMAGE_HEIGHT_IN_INCHES = 60.0

IMAGE_URL = 'https://cl.imagineapi.dev/assets/98091e8d-2d23-4030-abf1-65c21f493832/98091e8d-2d23-4030-abf1-65c21f493832.png'

# -------------------------------------------------------------------- Open the image

image = MiniMagick::Image.open(IMAGE_URL)
puts 'image_size: ' + (image['%[size]'].to_f / 1024 / 1024).to_s + 'MB'

# -------------------------------------------------------------------- Display image attributes, calculate image width / height in inches
# https://imagemagick.org/script/escape.php

pixel_width = image['%[width]'].to_i
pixel_height = image['%[height]'].to_i
puts 'pixel_width: ' + pixel_width.to_s
puts 'pixel_height: ' + pixel_height.to_s

units = image['%[units]']
puts 'units: ' + units.to_s

multiplier = 0
multiplier = 2.54 if units == 'PixelsPerCentimeter'

dpi_x = (image['%[resolution.x]'].to_f * multiplier).to_i
dpi_y = (image['%[resolution.y]'].to_f * multiplier).to_i
puts 'dpi_x: ' + dpi_x.to_s
puts 'dpi_y: ' + dpi_y.to_s

width_in_inches = pixel_width.to_f / dpi_x.to_f
height_in_inches = pixel_height.to_f / dpi_y.to_f
puts 'width_in_inches: ' + width_in_inches.to_s
puts 'height_in_inches: ' + height_in_inches.to_s

# -------------------------------------------------------------------- Calculate number of repeats needed

puts 'mapped image area width in inches: ' + MAPPED_IMAGE_WIDTH_IN_INCHES.to_s
puts 'mapped image area height in inches: ' + MAPPED_IMAGE_HEIGHT_IN_INCHES.to_s

nbr_width_repeats = (MAPPED_IMAGE_WIDTH_IN_INCHES / width_in_inches).ceil
nbr_height_repeats = (MAPPED_IMAGE_WIDTH_IN_INCHES / height_in_inches).ceil
puts 'nbr_width_repeats: ' + nbr_width_repeats.to_s
puts 'nbr_height_repeats: ' + nbr_height_repeats.to_s

# -------------------------------------------------------------------- Convert the file to a JPEG, as it will take less space / memory going forward

image.format 'jpeg'
puts 'image_jpg_size: ' + (image['%[size]'].to_f / 1024 / 1024).to_s + 'MB'

# -------------------------------------------------------------------- Tile the image

nbr_tiles = nbr_width_repeats * nbr_height_repeats
tile_format = nbr_width_repeats.to_s + 'x' + nbr_height_repeats.to_s
puts 'nbr_tiles: ' + nbr_tiles.to_s
puts 'tile_format: ' + tile_format.to_s

image_data = MiniMagick::Tool::Montage.new do |montage|
  montage.mode 'concatenate'
  nbr_tiles.times do
    montage << image.path
  end
  montage.tile tile_format
  montage.stdout
end

image_tiled = MiniMagick::Image.read(image_data)
puts 'image_tiled_size: ' + (image_tiled['%[size]'].to_f / 1024 / 1024).to_s + 'MB'

# -------------------------------------------------------------------- Crop the image to the correct width / height in inches

cropped_pixel_width = (MAPPED_IMAGE_WIDTH_IN_INCHES.to_f * dpi_x.to_f).ceil
cropped_pixel_height = (MAPPED_IMAGE_HEIGHT_IN_INCHES.to_f * dpi_y.to_f).ceil
puts 'cropped_pixel_width: ' + cropped_pixel_width.to_s
puts 'cropped_pixel_height: ' + cropped_pixel_height.to_s

crop_format = cropped_pixel_width.to_s + 'x' + cropped_pixel_height.to_s + '+0+0'
puts 'crop_format: ' + crop_format.to_s

image_tiled.crop(crop_format)
puts 'image_tiled_size: ' + (image_tiled['%[size]'].to_f / 1024 / 1024).to_s + 'MB'

# -------------------------------------------------------------------- Resize the image to what will be map / mocked up

resize_format = MAPPED_IMAGE_WIDTH_IN_PIXELS.to_s + 'x' + MAPPED_IMAGE_HEIGHT_IN_PIXELS.to_s
puts 'resize_format: ' + resize_format.to_s

image_tiled.resize(resize_format)
puts 'image_tiled_size: ' + (image_tiled['%[size]'].to_f / 1024 / 1024).to_s + 'MB'

tiled_pixel_width = image_tiled['%[width]'].to_i
tiled_pixel_height = image_tiled['%[height]'].to_i
puts 'tiled_pixel_width: ' + tiled_pixel_width.to_s
puts 'tiled_pixel_height: ' + tiled_pixel_height.to_s

# -------------------------------------------------------------------- Save the image in AWS s3

#image_tiled.write('output.jpeg')

image_path_on_aws = 'https://idesign-s3-bucket.s3.us-east-2.amazonaws.com/charlietest/test.jpeg'

# -------------------------------------------------------------------- Map the image with Media Modifier

values = {
  nr: MOCKUP_NBR,
  layer_inputs: [
    {
      id: '9c176e57-e96c-47a3-ad8b-8607ba9b1c16',
      data: image_path_on_aws,
      crop: {
        x: 0,
        y: 0,
        width: MAPPED_IMAGE_WIDTH_IN_PIXELS,
        height: MAPPED_IMAGE_HEIGHT_IN_PIXELS
      },
      checked: true
    }
  ]
}

puts RestClient.post(API_URL, values.to_json, AUTHORIZATION_HEADER).to_s if true

# -------------------------------------------------------------------- Delete the image in AWS s3

# --------------------------------------------------------------------