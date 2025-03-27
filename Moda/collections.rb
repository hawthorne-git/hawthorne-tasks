require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'

# Initialize Selenium WebDriver for Chrome
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless') # Run in headless mode (no UI)
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')

driver = Selenium::WebDriver.for :chrome, options: options
driver.navigate.to "https://shop.modafabrics.com/category/sweet-cecily-october"

# Wait for JavaScript to load
sleep 2

page_source = driver.page_source
doc = Nokogiri::HTML(page_source)

# base URL for Moda site
base_url = "https://shop.modafabrics.com"

# select product elements
doc.css('div.mk-category-grid-item').each do |product|
  begin
    # extract product title
    product_title = product.css('div.text-center.mt-2.mk-category-grid-name').text.strip
    puts 'Product Title: ' + product_title

    # extract product URL
    product_href = product.at_css('div.mk-category-grid-img a')['href'] rescue nil
    product_url = product_href ? "#{base_url}#{product_href}" : nil

    puts "Product URL: #{product_url}"

    # skip products
    skip_products = ["Assortment", "Asst", "AB", "PP", "LC", "JR"]

    # go to each product page if the URL exists
    if product_url

      # navigate to the product page
      driver.navigate.to product_url

      # wait for content to load
      sleep 2

      product_page_source = driver.page_source
      product_doc = Nokogiri::HTML(product_page_source)

      next if skip_products.any? { |keyword| product_title.include?(keyword) }

      # extract details
      designer_element = product_doc.css('p.mk-product-info').find { |p| p.text.include?("Designer:") }
      designer_name = designer_element ? designer_element.css('b').text.strip : "No designer found"

      sku_element = product_doc.css('p.mk-product-info').find { |p| p.text.include?("Stock #:") }
      sku = sku_element ? sku_element.css('b').text.strip : "No sku element found"

      fabric_type_element = product_doc.css('p.mk-product-info').find { |p| p.text.include?("Product Content:") }
      fabric_type = fabric_type_element ? fabric_type_element.css('b').text.strip : "No fabric type found"

      fabric_width_element = product_doc.css('p.mk-product-info').find { |p| p.text.include?("Type:") }
      fabric_width = fabric_width_element ? fabric_width_element.css('b').text.strip : "No fabric width found"

      collection_name_element = product_doc.css('p.mk-product-info').find { |p| p.text.include?("Group:") }
      collection_name = collection_name_element ? collection_name_element.css('b').text.strip : "No collection name found"

      color_element = product_doc.css('p.mk-product-info').find { |p| p.text.include?("Color:") }
      color = color_element ? color_element.css('b').text.strip : "No color found"

      upc_element = product_doc.css('p.mk-product-info').find { |p| p.text.include?("UPC:") }
      upc = upc_element ? upc_element.css('b').text.strip : "No UPC found"

      style_element = product_doc.css('div.mk-product-description p').first
      style = style_element ? style_element.text.strip : "No description found"

      # Extract the product image URL
      image_element = product_doc.css('div.pa-1.col-sm-10.col-9 img.mk-product-image')
      image_url = image_element.empty? ? "No image found" : image_element.attr('src').value

      # prints details
      puts "Designer Name: #{designer_name}"
      puts "Collection Name: #{collection_name}"
      puts "Style: #{style}"
      puts "Color: #{color}"
      puts "SKU: #{sku}"
      puts "Fabric Type: #{fabric_type}"
      puts "Fabric Width: #{fabric_width}"
      puts "UPC: #{upc}"
      puts "Image URL: #{image_url}"
      puts '                                                               '
      puts '---------------------------------------------------------------'
      puts '                                                               '
    end
  end
end

driver.quit