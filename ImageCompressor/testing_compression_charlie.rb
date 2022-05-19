require "vips"

im = Vips::Image.new_from_file 'C:/Users/ht-ruby/Desktop/mapped_image.png'

# finally, write the result back to a file on disk
im.write_to_file 'C:/Users/ht-ruby/Desktop/mapped_image_vips.png'