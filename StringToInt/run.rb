str = 'lizzyborden79@comcast.net'

str_as_int = 0

str.each_char { |c|
  str_as_int += c.ord
}

puts str_as_int.to_s