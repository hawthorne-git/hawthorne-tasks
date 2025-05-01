require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'
require 'uri'

# ----------------------------------------------------------------------------------------

COLLECTION_URL = 'https://www.rileyblakedesigns.com/Fabric/Coming-Soon/January-2026/Autumn-Woodland-2'

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

# fetch the HTML of the collection page
collection_html = URI.open(COLLECTION_URL).read
collection_doc = Nokogiri::HTML(collection_html)

# select product links
product_links = collection_doc.css('.facets-item-cell-grid-title')

# product types to skip, only want 44" fabric
skip_products = [
  "Rolie Polie", "Lightweight", "Stacker", "Fat Quarter Bundle", "Case Pack", "Swatch",
  "Book", "20 Yards", "1-Yard", "Wide Back", "Panel", "Quilt Pattern", "Booklet", "Quilt Boxed Kit"
]

# process product links
product_links.each do |link|
  product_title = link.css('span[itemprop="name"]').text.strip

  # skip any product that isn't 44" fabric
  next if skip_products.any? { |keyword| product_title.include?(keyword) }

  product_href = link['href']
  product_url = URI.join('https://www.rileyblakedesigns.com/', product_href).to_s

  puts "Found product: #{product_title}"
  puts "Product URL: #{product_url}"

  begin
    # Load product page in headless browser
    driver.navigate.to(product_url)

    # Wait for JS-rendered content to appear
    sleep 3

    # Get full page source with rendered JS content
    product_doc = Nokogiri::HTML(driver.page_source)

    # Extract product details
    product_info = product_doc.css('.product-info-list li')

    upc = extract_product_detail(product_info, 'UPC Code')
    sku = extract_product_detail(product_info, 'Item Number')
    fiber_content = extract_product_detail(product_info, 'Fiber Content')
    fabric_width = extract_product_detail(product_info, 'Width')
    designer_name = extract_product_detail(product_info, 'Designer')
    collection_name = extract_product_detail(product_info, 'Collection')
    item_description = extract_product_detail(product_info, 'Item Description')
    washing_instructions = extract_product_detail(product_info, 'Washing Instructions')

    # extract the full product title including colorway
    title_element = product_doc.at_css('.product-details-full-content-header-title[itemprop="name"]')
    full_title = title_element.text.strip if title_element

    # extract style and colorway from full_title
    if full_title && collection_name

      # remove the collection name from the start of the full title
      title_without_collection = full_title.sub(collection_name, '').strip

      # split remaining parts
      title_parts = title_without_collection.split

      if title_parts.length >= 2
        colorway = title_parts.last
        style = title_parts[0...-1].join(' ')
      end
    end

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
    puts "Style: #{style}"
    puts "Colorway: #{colorway}"
    puts "Collection name: #{collection_name}"
    puts "Item description: #{item_description}"
    puts "Washing instructions: #{washing_instructions}"
    puts "---------------------------------------------------------------"

  rescue => e
    puts "Error processing product at #{product_url}: #{e.message}"
  end
end

driver.quit




