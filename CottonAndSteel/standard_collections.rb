require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'

collection_styles = ["Having A Whale Of A Time", "Nothing But Blue Skies And Ocean Tides", "Mermaid Hair, Don\'t Care", "Wanderlust And Ocean Dust", "High Tides And Good Vibes"]

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
      style = product_doc.at_css('p[style="font-size:larger;"] strong').text.strip
      puts "Style: #{style}"
    end
  end
end
