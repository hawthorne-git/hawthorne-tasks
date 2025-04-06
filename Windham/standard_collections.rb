require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'

# Initialize Selenium WebDriver for Chrome
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless') # Run in headless mode (no UI)
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')

driver = Selenium::WebDriver.for :chrome, options: options
driver.navigate.to "https://windhamfabrics.com/collections/christmas-village?sort_by=manual&filter.p.vendor=Windham+Fabrics&filter.p.m.custom.item_category=Fabric+by+the+Yard"

# Wait for JavaScript to load
sleep 2

page_source = driver.page_source
doc = Nokogiri::HTML(page_source)

base_url = "https://windhamfabrics.com"
base_url_image = "https:"

skip_products = ["Assortment", "Wideback", "Sample", "Panel", "Fat Quarter"]

doc.css('.js-pagination-result').each do |product|
  begin
    product_url_page = product.at_css('a')['href']
    full_product_url = base_url + product_url_page

    if full_product_url
      # navigate to product page
      driver.navigate.to full_product_url

      # wait for content to load
      sleep 2

      product_page_source = driver.page_source
      product_doc = Nokogiri::HTML(product_page_source)

      product_details = product_doc.at_css('.misc-info').text.strip

      next if skip_products.any? { |keyword| product_details&.include?(keyword) }

      # extract style name
      style = product_doc.at_css('.custom-style').text.strip

      # extract sku
      sku_colorway_combined = product_doc.at_css('.product-sku-color-value.js-sku-color.h5').text.strip
      sku = sku_colorway_combined.sub(/\s+\S+$/, '')

      # extract colorway
      colorway = sku_colorway_combined.split(' ').last.strip

      # extract image URL
      image_url_raw = product_doc.at_css('.media--cover')['href']
      image_url_full = base_url_image + image_url_raw

      puts "------------------------------------------------------------------------------------- "
      puts "                                                                                      "
      puts "Style: #{style}"
      puts "Colorway: #{colorway}"
      puts "SKU: #{sku}"
      puts "Image URL: #{image_url_full}"
      puts "                                                                                      "
      puts "------------------------------------------------------------------------------------- "
    end
  end
end

driver.quit
