require 'rest-client'
require 'json'

TOKEN = 'v^1.1#i^1#f^0#p^3#I^3#r^0#t^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'
ORDER_ID = '02-00000-35508'

HEADERS = {
  Authorization: "Bearer #{TOKEN}",
  "Content-Type" => "application/json",
  Accept: "application/json",
  "Content-Language" => "en-US"
}

# add tracking number to order
def create_shipping_fulfillment(order_id)
  url = "https://api.sandbox.ebay.com/sell/fulfillment/v1/order/#{order_id}/shipping_fulfillment"

  body = {
    lineItems: [
      {
        lineItemId: "10000003496310"
      }
    ],
    shippingCarrierCode: "USPS",
    trackingNumber: "123456789012",
    shippedDate: Time.now.utc.iso8601
  }

  begin
    response = RestClient.post(url, body.to_json, HEADERS)
    puts "Tracking added: #{response.code}"
  rescue RestClient::ExceptionWithResponse => e
    puts "Tracking failed: #{e.response}"
  end
end

create_shipping_fulfillment(ORDER_ID)
