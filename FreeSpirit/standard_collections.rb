require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'

# Initialize Selenium WebDriver for Chrome
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless') # Run in headless mode (no UI)
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')

driver = Selenium::WebDriver.for :chrome, options: options
driver.navigate.to "https://freespiritfabrics.com/fabric-lines/whats-new/after-the-rain/"

# Wait for JavaScript to load
sleep 2

page_source = driver.page_source
doc = Nokogiri::HTML(page_source)

skip_products = ["Collection", "Denise Burkitt"]

# Iterate over each product card
doc.css('.card').each do |product|
  begin
    product_url = product.at_css('a')['href']
    puts product_url

    if product_url
      # navigate to product page
      driver.navigate.to product_url

      # wait for content to load
      sleep 2

      product_page_source = driver.page_source
      product_doc = Nokogiri::HTML(product_page_source)

      # extract details
      product_details = product_doc.at_css('.productView-title').text.strip
      puts product_details

      next if skip_products.any? { |keyword| product_details.include?(keyword) }

      # extract style name
      style = product_details.split(' - ')[0]

      # extract colorway
      colorway = product_details.split(' - ')[1].split('||')[0]

      # extract sku
      sku = product_doc.at_css('dd.productView-info-value[data-product-sku]').text.strip

      # extract image URL
      image_url_raw = product_doc.at_css('img.productView-image--default')['src']

      upc = nil

      puts "------------------------------------------------------------------------------------- "
      puts "                                                                                      "
      puts "Style: #{style}"
      puts "Colorway: #{colorway}"
      puts "SKU: #{sku}"
      puts "Image URL: #{image_url_raw}"
      puts "                                                                                      "
      puts "------------------------------------------------------------------------------------- "
    end

  end
end

driver.quit

