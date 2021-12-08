require "base64"
require "mini_magick"

fabric = "autumn"
tiles = 4

puts 'Magic code goes here ...  Charlie Here!'
img = MiniMagick::Image.open("C:/Users/hawth/Desktop/#{fabric}.png")

img.resize("25%")

MiniMagick::Tool::Montage.new do |montage|
  montage.mode 'concatenate'
  tiles.times do
    montage << img.path
  end
  # montage.tile '3x3'
  montage << "Tiles/tile#{fabric}x#{tiles}.png"
end





#img = MiniMagick::Image.open("C:/Users/hawth/Desktop/flower.png")
#background_dir = File.join(*%W[#{Rails.root} app assets images background_negative.png])
#background = MiniMagick::Image.open(background_dir)
#background.combine_options do |c|
  # c.size "#{img['width']}x#{img['height']}"
  # c.tile background_dir
#end
#background
#img = img.composite(background) do |c|
  # c.compose "ColorDodge"
#end







#base64_image =
# File.open("C:/Users/hawth/Desktop/flower.png", "rb") do |file|
#   Base64.strict_encode64(file.read)
# end

#puts base64_image


  #{
  #   "method": "get",
  #   "url": "https://api.mediamodifier.com/mockups",
  #   "headers": {
  #     "api_key": "",
  #     "Content-Type": "application/json"
  #   }
  #}

  # "nr" - which mockup
  # "layer_inputs"
  #   "id"
  #   "data" -base64 image
  #   "crop"
  #     "x" & "y" -usually keep at 0,0
  #     "width" & "height" -depends on mockup
  #   "check" if it renders - doesnt mean it is going to come out correct
  # "id" -usually the background id
  #   "check"
  #   "color"
  #     "red"
  #     "green"
  #     "blue"
