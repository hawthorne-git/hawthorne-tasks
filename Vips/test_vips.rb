require "vips"

im = Vips::Image.new_from_file 'C:\Users\hawth\RubymineProjects\hawthorne-tasks\72.png'

# put im at position (100, 100) in a 3000 x 3000 pixel image,
# make the other pixels in the image by mirroring im up / down /
# left / right, see
# https://libvips.github.io/libvips/API/current/libvips-conversion.html#vips-embed
im = im.embed 100, 100, 3000, 3000, extend: :mirror

# multiply the green (middle) band by 2, leave the other two alone
im *= [1, 2, 1]

# make an image from an array constant, convolve with it
mask = Vips::Image.new_from_array [
                                    [-1, -1, -1],
                                    [-1, 16, -1],
                                    [-1, -1, -1]], 8
im = im.conv mask, precision: :integer

# finally, write the result back to a file on disk
im.write_to_file 'vips_test.png'
