require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'


collection_styles = ["Garden Study", "Ribboned Blossoms", "Heathland Allusion", "Floral Metaphor", "Beloved Memoir", "Tilted Horizon", "Subtle Parallelism", "Plaid Tales", "Striped Narratives", "Kerchief Folklore", "Memoir Bound"]

# Initialize Selenium WebDriver for Chrome
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless') # Run in headless mode (no UI)
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')

driver = Selenium::WebDriver.for :chrome, options: options
driver.navigate.to "https://www.artgalleryfabrics.com/cgi-bin/fabricshop/gallery.cgi?Category=472"

# Wait for JavaScript to load
sleep 2

page_source = driver.page_source
doc = Nokogiri::HTML(page_source)

# select product elements
doc.css('.masonbox.gallerycol5').each do |product|
  begin
    # extract product title
    product_title = product.at_css('div[style="font-weight: bold"]').text.strip
    puts 'Product Title: ' + product_title

    # extract product URL
    product_url = product.at_css('a')['href'] rescue nil

    if product_url

      # navigate to the product page
      driver.navigate.to product_url

      # wait for content to load
      sleep 2

      product_page_source = driver.page_source
      product_doc = Nokogiri::HTML(product_page_source)

      # extract details
      designer_element = product_doc.css('div.five.columns p em').find { |em| em.text.include?("DESIGNED BY") }
      designer_name = designer_element ? designer_element.text.gsub("DESIGNED BY", "").strip : "No designer found"
      designer_name = designer_name.split.map(&:capitalize).join(' ')

      style = product_doc.css('div.five.columns div[style="font-size: 1.2em; font-weight: bold"]').text.strip

      if collection_styles.any? { |collection_style| style.include?(collection_style) }
        matched_style = collection_styles.find { |collection_style| style.include?(collection_style) }

        colorway = style.sub(matched_style, '').strip

        if colorway.empty?
          colorway = "Multi"
        end

        puts "Colorway: #{colorway}"
      else
        puts "No matching collection style for: #{style}"
      end

      image_element = product_doc.css('div.seven.columns img').first
      image_url = image_element['src'] rescue nil

      sku = product_doc.css('div.seven.columns div[style="font-size: .8em; font-weight: bold"]').text.strip

      # prints details
      puts "Designer: #{designer_name}"
      puts "Style: #{style}"
      puts "Image URL: #{image_url}"
      puts "SKU: #{sku}"
      puts "Colorway: #{colorway}"

    end
  end
end

driver.quit