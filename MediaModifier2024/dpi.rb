require 'mini_magick'

# -------------------------------------------------------------------- Constants

IMAGE_URL = 'https://idesign-s3-bucket.s3.us-east-2.amazonaws.com/tdbam8rca2b43mqlu3rizopwwpot'

DPIs = [72, 84, 96, 108, 120, 132, 144]

# --------------------------------------------------------------------

DPIs.each do |dpi|

  puts ''
  puts ''

  image = MiniMagick::Image.open(IMAGE_URL)
  puts 'image_size: ' + (image['%[size]'].to_f / 1024 / 1024).to_s + 'MB'

  image.density (dpi / 2.54).to_i

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

  image.write(dpi.to_s + '.png')

end

# --------------------------------------------------------------------