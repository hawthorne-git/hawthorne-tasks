require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'

# Initialize Selenium WebDriver for Chrome
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless') # Run in headless mode (no UI)
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')

driver = Selenium::WebDriver.for :chrome, options: options
driver.navigate.to "http://cottonandsteelfabrics.com/long-time-no-sea-c-1_775_1071.html?page=1&sort=3a"

# Wait for JavaScript to load
sleep 2

page_source = driver.page_source
doc = Nokogiri::HTML(page_source)

doc.css('.item.col-ms-6.col-sm-4.grid-group-item').each do |product|
  begin
    product_url = product.at_css('a')['href']
    puts product_url

    if product_url
      # navigate to the product page
      driver.navigate.to product_url

      # wait for content to load
      sleep 2

      product_page_source = driver.page_source
      product_doc = Nokogiri::HTML(product_page_source)

      # extract details
      product_details = product_doc.at_css('p[style="font-size:larger;"] strong').text.strip

      # extract style name
      style = product_details.split(' - ')[1]
      puts "Style: #{style}"

      # extract colorway
      colorway_full = product_details.split(' - ')[2]
      colorway = colorway_full.sub(/ Fabric$/, '').strip
      puts "Colorway: #{colorway}"

      # extract SKU
      sku = product_details.split.first
      puts "SKU: #{sku}"

      # extract image URL
      image_url_cs = "https://www.cottonandsteelfabrics.com/"
      image_url_raw = product_doc.at_css('.pd_image_fabric img')['src']
      image_url = image_url_cs + image_url_raw
      puts "Image: #{image_url}"

      # extract UPC
      upc = product_doc.at_css('span[itemprop="gtin13"]').text.strip
      puts "UPC: #{upc}"
      puts "------------------------------------------------------------------------------------- "
    end
  end
end
