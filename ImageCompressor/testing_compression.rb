require "vips"
require 'open-uri'

puts " file loading"
image_path = 'C:/Users/ht-ruby/Desktop/mapped_image.png'
temp_png = "temp/1_image_png.png"
temp_jpg = "temp/2_image_jpeg.jpg"
temp_webp = "temp/final2reduce4.webp"

a = Vips::Image.new_from_file image_path
a.pngsave(temp_png, :compression => 1, :palette => true, :strip => true)
a.jpegsave(temp_jpg, :optimize_coding => true)
b = Vips::Image.new_from_file temp_jpg
b.webpsave(temp_webp, :min_size => true)

#resize later find out which reduction works better png or jpg