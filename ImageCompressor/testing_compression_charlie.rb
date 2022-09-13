require "vips"
require 'open-uri'

image_path = "C:/Users/hawth/Desktop/Luna Fawn.png"
temp_png = "C:/Users/hawth/Desktop/1_image_png.png"
temp_jpg = "C:/Users/hawth/Desktop/2_image_jpeg.jpg"
temp_webp = "C:/Users/hawth/Desktop/final2reduce4.webp"

a = Vips::Image.new_from_file image_path
a.pngsave(temp_png, :compression => 1, :palette => true, :strip => true)
a.jpegsave(temp_jpg, :optimize_coding => true)
b = Vips::Image.new_from_file temp_jpg
b.webpsave(temp_webp, :min_size => true)

#resize later find out which reduction works better png or jpg