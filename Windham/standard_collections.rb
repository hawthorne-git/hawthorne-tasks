require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'

# Initialize Selenium WebDriver for Chrome
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless') # Run in headless mode (no UI)
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')

driver = Selenium::WebDriver.for :chrome, options: options
driver.navigate.to "https://windhamfabrics.com/collections/ocean-life"

# Wait for JavaScript to load
sleep 2

page_source = driver.page_source
doc = Nokogiri::HTML(page_source)

base_url = "https://windhamfabrics.com"

skip_products = ["Assortment", "Wideback", "Sample", "Panel", "Fat Quarter"]

doc.css('.js-pagination-result').each do |product|
  begin
    product_url = product.at_css('a')['href']
    puts base_url + product_url
  end
end
