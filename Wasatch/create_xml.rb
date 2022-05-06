require 'mini_magick'

ready_path = "C:/Users/hawth/Hawthorne Dropbox/Digital Printing Production/Temp/STRIKE_OFF/ready.txt"
done_path = "C:/Users/hawth/Hawthorne Dropbox/Digital Printing Production/Temp/STRIKE_OFF/done.txt"
folder_path = "C:/Users/hawth/Hawthorne Dropbox/Digital Printing Production/Temp/STRIKE_OFF/"
image_folder = []

# check if ready.txt is there and done.txt is not.
if File.file?(ready_path) && !File.file?(done_path)
  arr_scale = eval(File.open(ready_path).read)

# See if there is a folder in STRIKE_OFF
  Dir.chdir(folder_path) do
    folder_array = Dir.glob('*').select { |f| File.directory? f }

    # for each folder create a path
      folder_array.each do |fold|
      direct_path = folder_path + fold

      # go through each folder and make a hash of the folder with image details
      Dir.foreach(direct_path) do |image_name|
        next if image_name == '.' or image_name == '..' or image_name == 'ready.txt'
        image_path = (direct_path + '/'+ image_name)
        img = MiniMagick::Image.new(image_path)
        res_w = img["%x"]
        res_h = img['%y']
        img_w = img.width / res_w.to_f
        img_h = img.height / res_h.to_f
        file_hash = {image_path: image_path, image_name: image_name, x_size: img_w.round(4), y_size: img_h.round(4)}
        image_folder.push(file_hash)
      end

      #create a xml for each scale with each image hash
      arr_scale.each do |scale|
        x_coordinate  = 0.0000
        y_coordinate = 0.0000
        longest = 0.0000
        xml_text = ''
        xml_text += '<?xml version="1.0" encoding="utf-8"?>'
        xml_text += '<WASATCH ACTION=JOB>'
        xml_text += '<LAYOUT NOTES="' + fold.gsub(" ", "_").upcase + '_' + scale.to_s + '">'

        image_folder.each do |file|

          scaling =  scale / 100.to_f
          xml_text += '<PAGE XPOSITION=' + x_coordinate.round(4).to_s + ' YPOSITION=' + y_coordinate.round(4).to_s + '>'
          xml_text += '<Copies>0</Copies>'
          xml_text += '<FileName>' + file[:image_path] + '</FileName>'
          xml_text += '<Scale>' + scale.to_s + '</Scale>'
          xml_text += '<IMGCONF>Woven_Profile</IMGCONF>'
          xml_text += '</PAGE>'

          x_coordinate = (file[:x_size] * scaling) + x_coordinate
          if (file[:y_size] * scaling ) > longest
            longest = file[:y_size] * scaling
          end

          if x_coordinate > 56
            y_coordinate += longest
            x_coordinate = 0.0000
            longest = 0.0000
          end
        end
        xml_text += '</LAYOUT>'
        xml_text += '</WASATCH>'
        #--------------------- Needs a new path
        open(fold.gsub(" ", "_").upcase + '_' + scale.to_s + '.xml', 'a') do |f|
          f.puts xml_text
        end
      end
    end
  end
end
