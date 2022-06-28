require 'mini_magick'

# Looking to copy changing a rose from red to green via profile
# Source: https://legacy.imagemagick.org/discourse-server/viewtopic.php?t=22444

path_to_project = 'C:\Users\ht-ruby\RubymineProjects\hawthorne-tasks\ApplyICCProfile'

MiniMagick::Tool::Convert.new do |convert|
  convert << path_to_project + '\rose\rose.png'
  convert.profile path_to_project + '\profiles\sRGB_v4_ICC_preference.icc'
  convert.profile path_to_project + '\profiles\snibgoGBRX.icc'
  convert << path_to_project + '\rose\green_rose.png'
end
