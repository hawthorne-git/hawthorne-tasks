require 'open-uri'
require 'nokogiri'

# Base URL of the website
base_url = "https://www.rileyblakedesigns.com"

# URL for Riley Blake collection
collection_url = "#{base_url}/Fabric/Basics/Confetti-Cottons?=page1"

# Fetch the HTML of the collection page
html = URI.open(collection_url).read
doc = Nokogiri::HTML(html)

# Select product links
product_links = doc.css('.facets-item-cell-grid-title')

# Product types to skip, only want 44" fabric
skip_products = ["Rolie Polie", "Stacker", "Fat Quarter Bundle", "Case Pack", "Swatch", "20 Yards"]

# Process product links
product_links.each do |link|
  product_title = link.css('span[itemprop="name"]').text.strip

  # Skip any product that isn't 44" fabric
  if skip_products.any? { |keyword| product_title.include?(keyword) }
    next
  end

  product_href = link['href']

  # Build full URL
  product_url = "#{base_url}#{product_href}"

  puts "Found product: #{product_title}"
  puts "Product URL: #{product_url}"

  # Fetch product page
  begin
    product_html = URI.open(product_url).read
    product_doc = Nokogiri::HTML(product_html)

    # Extract product details
    upc_code = product_doc.css('.list-details p').find { |p| p.text.include?('UPC Code') }
    sku_number = product_doc.css('.list-details p').find { |p| p.text.include?('Item Number') }
    fiber_content = product_doc.css('.list-details p').find { |p| p.text.include?('Fiber Content') }
    fabric_width = product_doc.css('.list-details p').find { |p| p.text.include?('Width') }
    designer_name = product_doc.css('.list-details p').find { |p| p.text.include?('Designer') }
    collection_name = product_doc.css('.list-details p').find { |p| p.text.include?('Collection') }
    item_description = product_doc.css('.list-details p').find { |p| p.text.include?('Item Description') }
    washing_instructions = product_doc.css('.list-details p').find { |p| p.text.include?('Washing Instructions') }

    # Extract the image URL
    image_element = product_doc.css('div.item-details-image-gallery-detailed-image img.center-block')
    image_url = image_element.attr('src').to_s if image_element

    # Encoding URL to remove space from image link
    encoded_image_url = URI::DEFAULT_PARSER.escape(image_url)

    if upc_code && sku_number && fiber_content && fabric_width && designer_name && collection_name && item_description && washing_instructions
      upc_number = upc_code.text.strip.split(':').last.strip
      sku_number = sku_number.text.strip.split(':').last.strip
      fiber_content = fiber_content.text.strip.split(':').last.strip
      fabric_width = fabric_width.text.strip.split(':').last.strip
      designer_name = designer_name.text.strip.split(':').last.strip
      collection_name = collection_name.text.strip.split(':').last.strip
      item_description = item_description.text.strip.split(':').last.strip
      washing_instructions = washing_instructions.text.strip.split(':').last.strip

      puts "UPC number: #{upc_number}"
      puts "SKU number: #{sku_number}"
      puts "Fiber content: #{fiber_content}"
      puts "Fabric width: #{fabric_width}"
      puts "Designer: #{designer_name}"
      puts "Collection name: #{collection_name}"
      puts "Item description: #{item_description}"
      puts "Washing instructions: #{washing_instructions}"
      puts "Image URL: #{encoded_image_url}"
      puts "---------------------------------------------------------------"
    else
      puts "Collection details not found"
    end
  rescue => e
    puts "Error fetching or parsing product page: #{e.message}"
  end
end




