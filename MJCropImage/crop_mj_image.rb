require 'mini_magick'

image_url = 'https://cdn.discordapp.com/attachments/1204522561439006794/1253428095684448416/idesignai_impressionism_painting_of_clouds_at_sunrise_2edf9eba-fcd9-4f8a-9334-26fc0d71d6d9.png?ex=6675d161&is=66747fe1&hm=8535c08426fb341a7535d55f9f9de6a1da9a21fd4a3ae608fa2fd31f14641056&'

image = MiniMagick::Image.open(image_url)

image_height = image['%[height]'].to_i
image_width = image['%[width]'].to_i

puts 'image height = ' + image_height.to_s
puts 'image width = ' + image_width.to_s

image_1_crop = (image_width / 2).to_s + 'x' + (image_height / 2).to_s + '+0+0'
result = image.crop image_1_crop
result.write 'C:\Users\ht-ruby\RubymineProjects\hawthorne-tasks\MJCropImage\1.png'

image = MiniMagick::Image.open(image_url)
image_2_crop = (image_width / 2).to_s + 'x' + (image_height / 2).to_s + '+' + (image_width / 2).to_s + '+0'
result = image.crop image_2_crop
result.write 'C:\Users\ht-ruby\RubymineProjects\hawthorne-tasks\MJCropImage\2.png'

image = MiniMagick::Image.open(image_url)
image_3_crop = (image_width / 2).to_s + 'x' + (image_height / 2).to_s + '+0+' + (image_height / 2).to_s
result = image.crop image_3_crop
result.write 'C:\Users\ht-ruby\RubymineProjects\hawthorne-tasks\MJCropImage\3.png'

image = MiniMagick::Image.open(image_url)
image_4_crop = (image_width / 2).to_s + 'x' + (image_height / 2).to_s + '+' + (image_width / 2).to_s + '+' + (image_height / 2).to_s
result = image.crop image_4_crop
result.write 'C:\Users\ht-ruby\RubymineProjects\hawthorne-tasks\MJCropImage\4.png'