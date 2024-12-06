require 'open-uri'
require 'nokogiri'

# URL for Riley Blake collection
url = 'https://www.rileyblakedesigns.com/Fabric/Basics/Confetti-Cottons'

# Fetch the HTML
html = URI.open(url).read

# Parse the HTML with Nokogiri
doc = Nokogiri::HTML(html)

# Select all elements with the class 'facets-item-cell-grid-title' (this is where each product lives)
titles = doc.css('.facets-item-cell-grid-title span[itemprop="name"]')

# Extract and print the product name and color
titles.each do |title|
  puts title.text.strip
end