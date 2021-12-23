require 'uri'
require 'net/http'
require 'openssl'
require 'json/ext'
require 'rest-client'
require "open-uri"
require 'mini_magick'
require 'base64'

# API tokens
ACCESS_TOKEN = ENV['DB_ACCESS_TOKEN']

#files
file_name = 'Painted Buffalo Check in French Gray'

SINGLE_REPEAT_TIF_IMAGE_PATH = "db_images/#{file_name}.tif"

SINGLE_REPEAT_PNG_IMAGE_PATH = 'mm_images/temp/1_image_png.png'

REPEATED_PNG_IMAGE_PATH = 'mm_images/temp/2_image_png_repeated.png'

REPEATED_PNG_RESIZED_IMAGE_PATH = 'mm_images/temp/3_image_png_repeated_resized.png'

REPEATED_PNG_RESIZED_CROPPED_IMAGE_PATH = 'mm_images/temp/4_image_png_repeated_resized_cropped.png'

MAPPED_IMAGE_PATH = "mm_images/#{file_name}_mapped_image.png"

DB_AUTHORIZATION_HEADER = {
  Authorization: 'Bearer ' + ACCESS_TOKEN,
  'content-type': :json,
  'Dropbox-Api-Path-Root': {".tag":'namespace_id', "namespace_id": '6653412160'}.to_json,
}

db_values = {
  path: "/for nick/fabric to test/#{file_name}.tif"
}

db_response = RestClient.post('https://api.dropboxapi.com/2/files/get_temporary_link', db_values.to_json, DB_AUTHORIZATION_HEADER)


db_response_link = JSON.parse(db_response)['link']

open(SINGLE_REPEAT_TIF_IMAGE_PATH, 'wb') do |file|
  file << URI.open(db_response_link).read
end

INPUT_IMAGE_DPI = 300.0

# image width / height in inches and pixels

image = "pillow"
MAPPED_IMAGE_WIDTH_IN_INCHES = 18
MAPPED_IMAGE_HEIGHT_IN_INCHES = 18
MAPPED_IMAGE_WIDTH_IN_PIXELS = 359
MAPPED_IMAGE_HEIGHT_IN_PIXELS = 319
mockup_nr = 54224
mockup_id = '8c4f0a65-3589-4f47-b0b2-6758851c7102'



# -----------------------------------------------------------------



MAPPED_IMAGE_MAX_SIDE_IN_INCHES = (MAPPED_IMAGE_WIDTH_IN_INCHES > MAPPED_IMAGE_HEIGHT_IN_INCHES) ? MAPPED_IMAGE_WIDTH_IN_INCHES : MAPPED_IMAGE_HEIGHT_IN_INCHES
puts 'Cropped object width in inches: ' + MAPPED_IMAGE_WIDTH_IN_INCHES.to_s
puts 'Cropped object height in inches: ' + MAPPED_IMAGE_HEIGHT_IN_INCHES.to_s


MAPPED_IMAGE_MAX_SIDE_IN_PIXELS = (MAPPED_IMAGE_WIDTH_IN_PIXELS > MAPPED_IMAGE_HEIGHT_IN_PIXELS) ? MAPPED_IMAGE_WIDTH_IN_PIXELS : MAPPED_IMAGE_HEIGHT_IN_PIXELS

# -----------------------------------------------------------------
# API details ...

MM_API_URL = 'https://api.mediamodifier.com/mockup/render'

MM_AUTHORIZATION_HEADER = {
  'Content-Type' => 'application/json',
  'api_key' => ENV['api_key']
}

# -----------------------------------------------------------------
# open the input file, a single repeated tif
# set format at png and save - this gives us a smaller sized file to work with; note that DPI changes

single_repeat_image_tif = MiniMagick::Image.open(SINGLE_REPEAT_TIF_IMAGE_PATH)
single_repeat_image_tif.format('png')
single_repeat_image_tif.write(SINGLE_REPEAT_PNG_IMAGE_PATH)

# -----------------------------------------------------------------
# open the input file that is saved as a single repeated png

single_repeat_image_png = MiniMagick::Image.open(SINGLE_REPEAT_PNG_IMAGE_PATH)

# -----------------------------------------------------------------
# determine how many repeats are needed in mapping
#
# calculate the image width and height in inches
# determine the lesser of the two (width / height) ...
# the number of repeats per side is mapped image side max / input image side min (and round up)

single_repeat_image_width_in_inches = single_repeat_image_png.dimensions[0] / INPUT_IMAGE_DPI
single_repeat_image_height_in_inches = single_repeat_image_png.dimensions[1] / INPUT_IMAGE_DPI
puts 'Single repeat image width in pixels / inches: ' + single_repeat_image_png.dimensions[0].to_s + ' / ' + single_repeat_image_width_in_inches.to_s
puts 'Single repeat image height in pixels / inches: ' + single_repeat_image_png.dimensions[1].to_s + ' / ' + single_repeat_image_height_in_inches.to_s

single_repeat_image_max_side_in_inches = (single_repeat_image_width_in_inches > single_repeat_image_height_in_inches) ? single_repeat_image_width_in_inches : single_repeat_image_height_in_inches
single_repeat_image_min_side_in_inches = (single_repeat_image_width_in_inches < single_repeat_image_height_in_inches) ? single_repeat_image_width_in_inches : single_repeat_image_height_in_inches
puts 'Single repeat image max side in inches: ' + single_repeat_image_max_side_in_inches.to_s
puts 'Single repeat image min side in inches: ' + single_repeat_image_min_side_in_inches.to_s

nbr_repeats_per_side = (MAPPED_IMAGE_MAX_SIDE_IN_INCHES / single_repeat_image_min_side_in_inches).ceil
puts '# Repeats per side: ' + nbr_repeats_per_side.to_s

# -----------------------------------------------------------------
# open the single repeated png and create a repeated file

nbr_repeats = nbr_repeats_per_side * nbr_repeats_per_side
tile_format = nbr_repeats_per_side.to_s + 'x' + nbr_repeats_per_side.to_s
puts '# Repeats: ' + nbr_repeats.to_s
puts 'MiniMagick Tile format: ' + tile_format

MiniMagick::Tool::Montage.new do |montage|
  montage.mode 'concatenate'
  nbr_repeats.times do
    montage << single_repeat_image_png.path
  end
  montage.tile tile_format
  montage << REPEATED_PNG_IMAGE_PATH
end

# -----------------------------------------------------------------
# the repeated file created is larger then needed as it:
# (A) is repeated on the inputted image min side to the mapped image max side, and rounded up (to be safe)
# (B) is at a scale of 300DPI vs what is used, which is significantly less

repeated_image_png = MiniMagick::Image.open(REPEATED_PNG_IMAGE_PATH)
puts 'Repeated image width in pixels / inches: ' + repeated_image_png.dimensions[0].to_s + ' / ' + (single_repeat_image_width_in_inches * nbr_repeats_per_side).to_s
puts 'Repeated image height in pixels / inches: ' + repeated_image_png.dimensions[1].to_s + ' / ' + (single_repeat_image_height_in_inches * nbr_repeats_per_side).to_s

pixels_to_resize = (MAPPED_IMAGE_MAX_SIDE_IN_PIXELS.to_f * (single_repeat_image_max_side_in_inches / single_repeat_image_min_side_in_inches)).ceil
resize_format = pixels_to_resize.to_s + 'x' + pixels_to_resize.to_s
puts 'Pixels per side to resize: ' + pixels_to_resize.to_s
puts 'Resize format: ' + resize_format

repeated_image_png.resize(resize_format)
repeated_image_png.write(REPEATED_PNG_RESIZED_IMAGE_PATH)

# -----------------------------------------------------------------
# prior to sending the image to be mapped, correct (crop) its size

repeated_image_resized_png = MiniMagick::Image.open(REPEATED_PNG_RESIZED_IMAGE_PATH)
puts 'Repeated image width in pixels: ' + repeated_image_resized_png.dimensions[0].to_s
puts 'Repeated image height in pixels: ' + repeated_image_resized_png.dimensions[1].to_s

crop_format = MAPPED_IMAGE_WIDTH_IN_PIXELS.to_s + 'x' + MAPPED_IMAGE_HEIGHT_IN_PIXELS.to_s + '!+0+0'
puts 'Crop format: ' + crop_format

repeated_image_png.crop(crop_format)
repeated_image_png.write(REPEATED_PNG_RESIZED_CROPPED_IMAGE_PATH)

# -----------------------------------------------------------------
# open the repeated and resized image in base64 format

repeated_resized_cropped_image_base64 = File.open(REPEATED_PNG_RESIZED_CROPPED_IMAGE_PATH, 'rb') do |file|
  Base64.strict_encode64(file.read)
end

# -----------------------------------------------------------------
# map the image

# define the request values to map the image
mm_values = {
  'nr': mockup_nr,
  'image_type': 'png',
  'layer_inputs': [
    {
      'id': mockup_id,
      'data': 'data:image/png;base64,' + repeated_resized_cropped_image_base64,
      'crop': {
        'x': 0,
        'y': 0,
        'width': MAPPED_IMAGE_WIDTH_IN_PIXELS,
        'height': MAPPED_IMAGE_HEIGHT_IN_PIXELS
      },
      'checked': true
    }
  ]
}

# request to map the image via their API
response = RestClient.post MM_API_URL, mm_values.to_json, MM_AUTHORIZATION_HEADER

# if the map was a success ...
# retrieve the base64 response and create a new image
# note that there is header text in the response that needs to be omitted
if JSON.parse(response)['success']
  File.open(MAPPED_IMAGE_PATH, 'wb') do |f|
    base64_response = JSON.parse(response)['base64']
    f.write(Base64.decode64(base64_response['data:image/png;base64,'.size, base64_response.size]))
  end
end