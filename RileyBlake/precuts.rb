require 'nokogiri'
require 'open-uri'

# URL for Riley Blake precuts
precuts_url = "https://www.rileyblakedesigns.com/Fabric/Precuts/Rolie-Polies?page=1"

# fetch the HTML of the precuts page
html = URI.open(precuts_url).read
doc = Nokogiri::HTML(html)

# base URL
base_url = "https://www.rileyblakedesigns.com"

# select product elements
doc.css('div.facets-item-cell-grid').each do |product|

  # extract product title
  product_title = product.css('.facets-item-cell-grid-title span[itemprop="name"]').text.strip

  # extract product URL from meta or anchor tag
  product_href = product.at('meta[itemprop="url"]')['content'] rescue nil
  product_url = product_href ? "#{base_url}#{product_href}" : nil
  product_url ||= "#{base_url}#{product.at('a.facets-item-cell-grid-title')['href']}" rescue nil

  puts "Found product: #{product_title}"
  puts "Product URL: #{product_url}"

  # fetch product page
  begin
    next unless product_url

    product_html = URI.open(product_url).read
    product_doc = Nokogiri::HTML(product_html)

    # extract product details
    upc_code = product_doc.css('.list-details p').find { |p| p.text.include?('UPC Code') }
    sku_number = product_doc.css('.list-details p').find { |p| p.text.include?('Item Number') }
    fiber_content = product_doc.css('.list-details p').find { |p| p.text.include?('Fiber Content') }
    fabric_width = product_doc.css('.list-details p').find { |p| p.text.include?('Width') }
    designer_name = product_doc.css('.list-details p').find { |p| p.text.include?('Designer') }
    collection_name = product_doc.css('.list-details p').find { |p| p.text.include?('Collection') }
    item_description = product_doc.css('.list-details p').find { |p| p.text.include?('Item Description') }
    washing_instructions = product_doc.css('.list-details p').find { |p| p.text.include?('Washing Instructions') }
    packaging_minimum = product_doc.css('.list-details p').find { |p| p.text.include?('Packaging') }

    # extract the image URL from the product page
    product_image_element = product_doc.css('div.item-details-image-gallery li img[itemprop="image"]')

    if product_image_element.any?
      # extract the first image URL from the gallery
      image_url = product_image_element.first.attr('src').to_s
      encoded_image_url = URI::DEFAULT_PARSER.escape(image_url)
      puts "Image URL: #{encoded_image_url}"
    else
      puts "No image found for this product"
    end

    if upc_code && sku_number && fiber_content && fabric_width && designer_name && collection_name && item_description && washing_instructions
      upc_number = upc_code.text.strip.split(':').last.strip
      sku_number = sku_number.text.strip.split(':').last.strip
      fiber_content = fiber_content.text.strip.split(':').last.strip
      fabric_width = fabric_width.text.strip.split(':').last.strip
      designer_name = designer_name.text.strip.split(':').last.strip
      collection_name = collection_name.text.strip.split(':').last.strip
      item_description = item_description.text.strip.split(':').last.strip
      washing_instructions = washing_instructions.text.strip.split(':').last.strip
      packaging_minimum = packaging_minimum.text.strip.split(':').last.strip

      puts "UPC number: #{upc_number}"
      puts "SKU number: #{sku_number}"
      puts "Fiber content: #{fiber_content}"
      puts "Fabric width: #{fabric_width}"
      puts "Designer: #{designer_name}"
      puts "Collection name: #{collection_name}"
      puts "Item description: #{item_description}"
      puts "Washing instructions: #{washing_instructions}"
      puts "Image URL: #{encoded_image_url}"
      puts "Packaging Minimum: #{packaging_minimum}"
      puts "---------------------------------------------------------------"
    else
      puts "Collection details not found"
    end
  rescue => e
    puts "Error fetching or parsing product page: #{e.message}"
  end
end


