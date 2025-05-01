require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'
require 'uri'

# URL for Riley Blake precuts
precuts_url = "https://www.rileyblakedesigns.com/Fabric/Precuts/10-Stackers/Release-Date-Facet/February-2026,January-2026"

# method to extract product-info
def extract_product_detail(product_info, title)
  li = product_info.find { |li| li.at_css('.product-info-title')&.text&.include?(title) }
  li&.at_css('.product-information-detail')&.text&.strip
end

# start a headless Chrome browser
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')
driver = Selenium::WebDriver.for :chrome, options: options

driver.navigate.to(precuts_url)

sleep 3

precuts_html = driver.page_source
precuts_doc = Nokogiri::HTML(precuts_html)

# base URL
base_url = "https://www.rileyblakedesigns.com"

# select product links
product_links = precuts_doc.css('a.facets-item-cell-grid-title')

# process each product link
product_links.each do |link|
  product_title = link.css('span[itemprop="name"]').text.strip
  product_href = link['href']
  product_url = URI.join(base_url, product_href).to_s

  puts "Found product: #{product_title}"
  puts "Product URL: #{product_url}"

  begin
    driver.navigate.to(product_url)

    sleep 3

    product_doc = Nokogiri::HTML(driver.page_source)

    product_info = product_doc.css('.product-info-list li')

    upc = extract_product_detail(product_info, 'UPC Code')
    sku = extract_product_detail(product_info, 'Item Number')
    fiber_content = extract_product_detail(product_info, 'Fiber Content')
    fabric_width = extract_product_detail(product_info, 'Width')
    designer_name = extract_product_detail(product_info, 'Designer')
    collection_name = extract_product_detail(product_info, 'Collection')
    item_description = extract_product_detail(product_info, 'Item Description')
    washing_instructions = extract_product_detail(product_info, 'Washing Instructions')

    # extract the full product title
    title_element = product_doc.at_css('.product-details-full-content-header-title[itemprop="name"]')
    full_title = title_element.text.strip if title_element

    # extract the image URL
    image_element = product_doc.at_css('div.product-details-image-gallery-detailed-image img.center-block')
    image_url_raw = image_element&.[]('src')
    image_url = image_url_raw.gsub(' ', '%20')

    puts "UPC number: #{upc}"
    puts "SKU number: #{sku}"
    puts "Image URL: #{image_url}"
    puts "Full Title: #{full_title}"
    puts "Fiber content: #{fiber_content}"
    puts "Fabric width: #{fabric_width}"
    puts "Designer: #{designer_name}"
    puts "Collection name: #{collection_name}"
    puts "Item description: #{item_description}"
    puts "Washing instructions: #{washing_instructions}"
    puts "---------------------------------------------------------------"

  rescue => e
    puts "Error processing product at #{product_url}: #{e.message}"
  end
end

driver.quit



