require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'

# Initialize Selenium WebDriver for Chrome
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless') # Run in headless mode (no UI)
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')

driver = Selenium::WebDriver.for :chrome, options: options
driver.navigate.to "https://shop.modafabrics.com/category/precuts-103712?facets=user9_s%7COn+Order"

# Wait for JavaScript to load
sleep 2

page_source = driver.page_source
doc = Nokogiri::HTML(page_source)

# base URL for Moda site
base_url = "https://shop.modafabrics.com"

# select product elements
doc.css('div.mk-category-grid-item').each do |product|
  begin
    # Extract product title
    product_title = product.css('div.text-center.mt-2.mk-category-grid-name').text.strip

    # Extract product URL
    product_href = product.at_css('div.mk-category-grid-img a')['href'] rescue nil
    product_url = product_href ? "#{base_url}#{product_href}" : nil

    puts "Found product: #{product_title}"
    puts "Product URL: #{product_url}"

    # Check if the product if FQB, if so extract number of pieces
    if product_title.include?("AB")
      match = product_title.match(/AB (\d+)/) # Match "AB" followed by a number
      nbr_pieces = match ? match[1] : "No number after AB" # Extracted number
      puts "Number of Pieces (from FQB): #{nbr_pieces}"
    else
      nbr_pieces = "Not a FQB"
    end

    # Fetch product page
    begin
      next unless product_url

      driver.navigate.to product_url
      sleep 2 # Allow the product page to load

      product_page_source = driver.page_source
      product_doc = Nokogiri::HTML(product_page_source)

      # Extract designer name
      designer_element = product_doc.css('p.mk-product-info').find { |p| p.text.include?("Designer:") }
      designer_name = designer_element ? designer_element.css('b').text.strip : "No designer found"

      # Extract group name
      group_name_element = product_doc.css('p.mk-product-info').find { |p| p.text.include?("Group Name:") }
      group_name = group_name_element ? group_name_element.css('a').text.strip : "No group name found"

      # Extract number of pieces from product content
      nbr_pieces_element = product_doc.css('p.mk-product-info').find { |p| p.text.include?("Product Content:") }
      nbr_pieces = nbr_pieces_element ? nbr_pieces_element.css('b').text.strip : "No nbr pieces found"

      # Extract SKU
      sku_element = product_doc.css('p.mk-product-info').find { |p| p.text.include?("Stock #:") }
      sku = sku_element ? sku_element.css('b').text.strip : "No sku element found"

      # Extract type of precut
      precut_type_element = product_doc.css('p.mk-product-info').find { |p| p.text.include?("Type:") }
      precut_type = precut_type_element ? precut_type_element.css('b').text.strip : "No precut type found"

      # Extract UPC code
      upc_code_element = product_doc.css('p.mk-product-info').find { |p| p.text.include?("UPC:") }
      upc = upc_code_element ? upc_code_element.css('b').text.strip : "No UPC found"

      # Extract the product image URL
      image_element = product_doc.css('div.pa-1.col-sm-10.col-9 img.mk-product-image')
      image_url = image_element.empty? ? "No image found" : image_element.attr('src').value

      puts "Designer Name: #{designer_name}"
      puts "Group Name: #{group_name}"
      puts "Number of Pieces: #{nbr_pieces}"
      puts "SKU: #{sku}"
      puts "UPC: #{upc}"
      puts "Precut Type: #{precut_type}"
      puts "Image URL: #{image_url}"
      puts "---------------------------------------------------------------"

    rescue => e
      puts "Error fetching or parsing product page: #{e.message}"
    end

  rescue => e
    puts "Error extracting product: #{e.message}"
  end
end

driver.quit


