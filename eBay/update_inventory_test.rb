require 'rest-client'
require 'json'

TOKEN = 'v^1.1#i^1#f^0#r^0#I^3#p^3#t^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'

HEADERS = {
  Authorization: "Bearer #{TOKEN}",
  "Content-Type" => "application/json",
  Accept: "application/json",
  "Content-Language" => "en-US"
}

# update inventory by sku
def update_inventory_quantity(sku, updated_quantity)
  url = "https://api.sandbox.ebay.com/sell/inventory/v1/inventory_item/#{sku}"

  body = {
    availability: {
      shipToLocationAvailability: {
        quantity: updated_quantity
      }
    }
  }

  begin
    response = RestClient.put(url, body.to_json, HEADERS)
    puts "Inventory updated successfully for SKU #{sku} with quantity #{updated_quantity}"
  rescue RestClient::ExceptionWithResponse => e
    puts "Failed to update inventory: #{e.response}"
  end
end

# get offerId from listing by sku
def get_offer_id(sku)
  url = "https://api.sandbox.ebay.com/sell/inventory/v1/offer?sku=#{sku}"

  begin
    response = RestClient.get(url, HEADERS)
    data = JSON.parse(response.body)

    # find offerId in first array
    if data['offers'] && data['offers'].any?
      offer_id = data['offers'][0]['offerId']
      puts "Found offer ID: #{offer_id}"
      return offer_id
    else
      puts "No offer found for SKU #{sku}"
      return nil
    end
  rescue RestClient::ExceptionWithResponse => e
    puts "Couldn\'t fetch offer: #{e.response}"
    return nil
  end
end

# update offer quantity by found offerId
def update_offer_quantity(offer_id, quantity)
  url = "https://api.sandbox.ebay.com/sell/inventory/v1/offer/#{offer_id}"

  body = {
    availableQuantity: quantity
  }

  begin
    response = RestClient.put(url, body.to_json, HEADERS)
    puts "Offer quantity updated to #{quantity}"
  rescue RestClient::ExceptionWithResponse => e
    puts "Couldn\'t update offer: #{e.response}"
  end
end

# sku and new quantity
sku = 'test-12890122'
new_quantity = 6

update_inventory_quantity(sku, new_quantity)

offer_id = get_offer_id(sku)
update_offer_quantity(offer_id, new_quantity) if offer_id