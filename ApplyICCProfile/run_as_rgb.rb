require 'mini_magick'

path_to_project = 'C:\Users\ht-ruby\RubymineProjects\hawthorne-tasks\ApplyICCProfile'


MiniMagick::Tool::Convert.new do |convert|
  convert << path_to_project + '\as_rgb\black.tif'
  convert.strip
  convert.profile path_to_project + '\profiles\sRGB_v4_ICC_preference.icc'
  convert.profile path_to_project + '\profiles\t2_rgb_2.icc'
end
