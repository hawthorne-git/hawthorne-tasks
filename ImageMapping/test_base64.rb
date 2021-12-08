
require "base64"



base64_image =
  File.open("C:/Users/hawth/Desktop/flower.png", "rb") do |file|
    Base64.strict_encode64(file.read)
  end

# decode64
img_from_base64 = Base64.decode64(base64_image)
# => "\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\xAA\x00\x00\x00\xAA\b\x06\x00\x00\x00=v\xD4\x82\x00\x00\x00IDATx\x9C\xEC\xBDi\x98%Wy\xE7\xF9;[D\xDC-3++k\xDF\xF7U\xA2T\x92J*\xAD\xA5}A`\ff\xB1\xB11\ ..."

# cut the data where it seems to hold the filetype
img_from_base64[0,8]
# => "\x89PNG\r\n\x1A\n"

# find file type
filetype = /(png|jpg|jpeg|gif|PNG|JPG|JPEG|GIF)/.match(img_from_base64[0,16])[0]
# name the file
filename = "zigzagflower"

# write file
file = filename << '.' << filetype
File.open(file, 'wb') do|f|
  f.write(img_from_base64)
end