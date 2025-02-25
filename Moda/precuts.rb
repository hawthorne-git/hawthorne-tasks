require 'selenium-webdriver'

# Initialize Selenium WebDriver for Chrome
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless') # Run in headless mode (no UI)
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')

driver = Selenium::WebDriver.for :chrome, options: options
driver.navigate.to "https://shop.modafabrics.com/category/precuts-103712?facets=user9_s%7COn+Order"

# Wait for JavaScript to load (adjust time if necessary)
sleep 5

# Extract product elements
products = driver.find_elements(css: 'div.mk-category-grid-item')

products.each do |product|
  begin
    # Extract product title
    product_title = product.find_element(css: 'div.text-center.mt-2.mk-category-grid-name').text.strip

    # Extract product URL
    product_href = product.find_element(css: 'div.mk-category-grid-img a')&.attribute('href')

    puts "Found product: #{product_title}"
    puts "Product URL: #{product_href}"
  rescue => e
    puts "Error extracting product: #{e.message}"
  end
end

driver.quit
