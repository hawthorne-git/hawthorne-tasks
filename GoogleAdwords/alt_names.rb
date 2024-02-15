def alt_names(name)

  # first take the name and downcase it
  name = name.downcase.strip

  # create a list of names, and at first start with just the name
  names = [name]

  # if ends with either design or designs ...
  # ex: 'paint love design', adds: (1) 'paint love designs', (2) 'paint love'
  if name.end_with? ' design'
    names.push name.gsub(' design', ' designs')
    names.push name.gsub(' design', '').strip
  elsif name.end_with? ' designs'
    names.push name.gsub(' designs', ' design')
    names.push name.gsub(' designs', '').strip
  end

  # if ends with either co or co. or company ...
  # ex: 'paint love co', adds: (1) 'paint love co.', (2) 'paint love company', (3) 'paint love'
  if name.end_with? ' co'
    names.push name.gsub(' co', ' co.')
    names.push name.gsub(' co', ' company')
    names.push name.gsub(' co', '')
  elsif name.end_with? ' co.'
    names.push name.gsub(' co.', ' co')
    names.push name.gsub(' co.', ' company')
    names.push name.gsub(' co.', '')
  elsif name.end_with? ' company'
    names.push name.gsub(' company', ' co')
    names.push name.gsub(' company', ' co.')
    names.push name.gsub(' company', '')
  end

  # if ends with either art or studio ...
  # ex 'paint love studio', adds: (1) 'paint love'
  names.push name.gsub(' art', '') if name.end_with? ' art'
  names.push name.gsub(' studio', '') if name.end_with? ' studio'

  # character replacements ...
  # ex: 'paint & love studio', adds: (1) 'paint and love studio'
  names.clone.each do |n|
    names.push n.gsub('.', '') if n.include? '.'
    names.push n.gsub('-', ' ') if n.include? '-'
    names.push n.gsub(' & ', ' and ') if n.include? ' & '
    names.push n.gsub(' and ', ' & ') if n.include? ' and '
  end

  # remove non unique names
  names = names.uniq

  # delete names not wanted
  # ex: 'paint love &'
  names.each do |n|
    names.delete(n) if n.end_with? ' &'
    names.delete(n) if n.end_with? ' and'
  end

  # return the list of names
  names

end

puts alt_names('THE ORIGINAL MORRIS & CO')