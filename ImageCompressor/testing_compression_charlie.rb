require 'image_processing/mini_magick'

image_path = 'C:/Users/hawth/Desktop/Luna Fawn.png'

image = MiniMagick::Image.open(image_path)

processed = ImageProcessing::MiniMagick.source(image).resize_to_limit(400, 400).strip.call