require 'open-uri'
require 'nokogiri'

# Method to format the product title into URL for product page
def format_title_for_url(title)
  # Remove the ™ symbol
  title = title.gsub('™', '')

  # Replace spaces with hyphens
  title = title.gsub(' ', '-')

  # Makes sure "Cotton" is "Cottons" (url for each product adds the "s")
  title = title.gsub('Confetti-Cotton', 'Confetti-Cottons')

  title
end

# Generate the URL from the product title
def generate_product_url(title)
  base_url = "https://www.rileyblakedesigns.com/"
  formatted_title = format_title_for_url(title)
  "#{base_url}#{formatted_title}"
end

# URL for Riley Blake collection
collection_url = 'https://www.rileyblakedesigns.com/Fabric/Basics/Confetti-Cottons'

# Fetch the HTML
html = URI.open(collection_url).read

# Parse the HTML
doc = Nokogiri::HTML(html)

# Select all elements with the class 'facets-item-cell-grid-title' (this is where each product name lives)
titles = doc.css('.facets-item-cell-grid-title span[itemprop="name"]')

# Extract the product title (processes 5 for now)
titles[0, 5].each do |title|
  product_title = title.text.strip
  puts "Found product: #{product_title}"

  # Generate URL for the specific product page based on the title
  product_url = generate_product_url(product_title)
  puts "Product URL: #{product_url}"

  # Fetch the product page and parse it
  begin
    product_html = URI.open(product_url).read
    product_doc = Nokogiri::HTML(product_html)

    # Extract the UPC code from the product details
    upc_code = product_doc.css('.list-details p').find { |p| p.text.include?('UPC Code') }
    sku_number = product_doc.css('.list-details p').find { |p| p.text.include?('Item Number') }

    # Print the UPC code if found
    if upc_code && sku_number
      upc_number = upc_code.text.strip.split(':').last.strip
      sku_number = sku_number.text.strip.split(':').last.strip

      puts "UPC number for #{product_title}: #{upc_number}"
      puts "SKU number for #{product_title}: #{sku_number}"
      puts "------------------------------------------------------------------------"
    else
      puts "UPC or SKU number not found for #{product_title}."
    end
  rescue => e
    puts "Failed to fetch or parse page for #{product_title}: #{e.message}"
  end
end

