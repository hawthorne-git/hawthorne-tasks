require 'mini_magick'

path_to_project = 'C:\Users\ht-ruby\RubymineProjects\hawthorne-tasks\ApplyICCProfile'


MiniMagick::Tool::Convert.new do |convert|
  convert << path_to_project + '\as_rgb\black.tif'
  convert.strip
  convert.profile path_to_project + '\profiles\sRGB_v4_ICC_preference.icc'
  convert.profile path_to_project + '\profiles\ISO22028-2_ROMM-RGB.icc'
  convert << path_to_project + '\as_rgb\output_42.tif'
end

MiniMagick::Tool::Convert.new do |convert|
  convert << path_to_project + '\as_rgb\110800.tif'
  convert.strip
  convert.colorspace 'sRGB'
  convert.profile path_to_project + '\profiles\sRGB_v4_ICC_preference.icc'
  convert.profile path_to_project + '\profiles\snibgoGBRX.icc'
  convert << path_to_project + '\as_rgb\output_1.png'
end

MiniMagick::Tool::Convert.new do |convert|
  convert << path_to_project + '\as_rgb\cyan.tif'
  convert.strip
  convert.colorspace 'sRGB'
  convert.profile path_to_project + '\profiles\sRGB_v4_ICC_preference.icc'
  convert.colorspace 'LAB'
  convert.profile path_to_project + '\profiles\random.icc'
  convert << path_to_project + '\as_rgb\output_2.png'
end





