require 'open-uri'
require 'nokogiri'

# Base URL of the website
base_url = "https://www.rileyblakedesigns.com"

# URL for Riley Blake collection
collection_url = "#{base_url}/Fabric/Basics/Confetti-Cottons?page=1"

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

    # Extract UPC and SKU
    upc_code = product_doc.css('.list-details p').find { |p| p.text.include?('UPC Code') }
    sku_number = product_doc.css('.list-details p').find { |p| p.text.include?('Item Number') }

    if upc_code && sku_number
      upc_number = upc_code.text.strip.split(':').last.strip
      sku_number = sku_number.text.strip.split(':').last.strip

      puts "UPC number: #{upc_number}"
      puts "SKU number: #{sku_number}"
      puts "---------------------------------------------------------------"
    else
      puts "UPC or SKU number not found."
    end
  rescue => e
    puts "Error fetching or parsing product page: #{e.message}"
  end
end




