require 'rubyXL'

# ------------------------------------------------------------

run_location_home = 'home'
run_location_work = 'work'

run_location = run_location_home

dir_path = ''
dir_path = 'C:\Users\ht-ruby\Desktop\joann' if run_location == run_location_home

# ------------------------------------------------------------

blank_file_path = dir_path + '\input\blank.xlsx'
joann_file_path = dir_path + '\input\RCERT ARTICLE CREATION VENDOR TEMPLATE Fabric2.xlsx'

file_path = blank_file_path

# ------------------------------------------------------------

# open the first worksheet via RubyXL
worksheet = RubyXL::Parser.parse(file_path)[0]

# ------------------------------------------------------------

row_nbr = 14

worksheet.add_cell((row_nbr - 1), 1, '176860')
worksheet.add_cell((row_nbr - 1), 2, 'Hawthorne')

puts Time.now.to_i.to_s

# ------------------------------------------------------------

write_file_path = dir_path + '\\' + Time.now.to_i.to_s + '.xlsx'

workbook.write(write_file_path)

# ------------------------------------------------------------

puts 'Done'
