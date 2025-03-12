require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'

# URL for Riley Blake collection
collection_url = "https://www.dearstelladesign.com/category/2-236009/alphabet-city#link-item-236119"

# Set up Selenium with Chrome in headless mode
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')  # Runs Chrome in headless mode
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')

# Instantiate the driver
driver = Selenium::WebDriver.for :chrome, options: options

# Go to the URL
driver.get(collection_url)

# Wait for JavaScript to load the content
sleep 3  # Wait for page to load dynamically, adjust the sleep time based on your observations

# Scrape the page
html = driver.page_source

# Parse the page with Nokogiri
doc = Nokogiri::HTML(html)

puts doc.css('div.P-Items-Listing-Class a[title]').inspect

# Select product links
product_links = doc.css('div.P-Items-Listing-Class a[title]').map { |link| link['href'] }

# Product types to skip, only want 44" fabric
skip_products = ["MOONSCAPE", "FAT QUARTER", "10", "STRIP PACKS", "DNR"]

# Process product links
product_links.each do |link|
  begin
    # Fetch product page
    product_url = URI.join(collection_url, link).to_s
    puts "Fetching product URL: #{product_url}" # Debug
    driver.get(product_url)

    # Wait for JavaScript to load product details (adjust the sleep time as needed)
    sleep 2

    # Extract product details
    product_html = driver.page_source
    product_doc = Nokogiri::HTML(product_html)

    product_title = product_doc.css('div.FocusPageDesc h1').text.strip rescue "Unknown Title"

    next if skip_products.any? { |keyword| product_title.include?(keyword) }

    sku = product_doc.css('div.FocusPageStylColor h2').text.strip rescue nil
    fiber_content = product_doc.css('.CustomeFieldFormatR').find { |e| e.text.include?('Cotton') }&.text.strip rescue nil
    fabric_width = product_doc.css('.CustomeFieldFormatR').find { |e| e.text.include?('inches') }&.text.strip rescue nil
    collection_name = product_doc.css('div.focus-view-field-row').find { |row| row.text.include?('COLLECTION') }.css('a[title]').text.strip rescue "Unknown Collection"
    image_element = product_doc.css('li.lslide.active img').first
    image_url = image_element ? image_element['src'] : nil

    # Replace non-breaking space with regular space in SKU
    sku = sku.gsub(/\u00A0/, ' ')  # Replace &nbsp; with regular space
    colorway = sku.split(/\s{2,}/).last rescue nil

    # Capitalize first letter of each word
    product_title = product_title.gsub(/\u00A0/, ' ') # Replace &nbsp; with regular space
    product_title = product_title.split.map(&:capitalize).join(' ') rescue nil
    colorway = colorway.split.map(&:capitalize).join(' ') rescue nil
    fiber_content = fiber_content.split.map(&:capitalize).join(' ') rescue nil
    fabric_width = fabric_width.split.map(&:capitalize).join(' ') rescue nil
    collection_name = collection_name.gsub(/\u00A0/, ' ') # Replace &nbsp; with regular space
    collection_name = collection_name.split.map(&:capitalize).join(' ') rescue nil

    # Output product details
    puts "Title: #{product_title}"
    puts "SKU: #{sku}" if sku
    puts "Fiber Content: #{fiber_content}" if fiber_content
    puts "Fabric Width: #{fabric_width}" if fabric_width
    puts "Collection: #{collection_name}"
    puts "Image URL: #{image_url}"
    puts "Product URL: #{product_url}"
    puts "Colorway: #{colorway}"
    puts "---------------------------------------------------------------"
  rescue => e
    puts "Error processing #{link}: #{e.class} - #{e.message}"
  end
end

# Close the driver
driver.quit




