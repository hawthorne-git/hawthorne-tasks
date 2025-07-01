require 'rest-client'
require 'json'

TOKEN = 'v^1.1#i^1#r^0#p^3#I^3#f^0#t^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'
PAYMENT_POLICY_ID = '6210033000'
RETURN_POLICY_ID = '6210034000'
FULFILLMENT_POLICY_ID = '6210028000'

HEADERS = {
  Authorization: "Bearer #{TOKEN}",
  "Content-Type" => "application/json",
  Accept: "application/json",
  "Content-Language" => "en-US"
}

# create inventory item
begin
  inventory_item_body = {
    product: {
      title: "Test",
      description: "Test description",
      aspects: { Brand: ["HSCO"] },
      imageUrls: ["https://hawthorne-s3-bucket.s3.us-east-2.amazonaws.com/static-image-assets/Logo+FINAL+WEBP.webp"],
      category: { categoryId: "261731" }
    },
    availability: {
      shipToLocationAvailability: {
        quantity: 1
      }
    },
    categoryId: '28162',
    merchantLocationKey: "1",
    listing: {
      marketplaceId: "EBAY_US",
      location: {
        country: "US",
        postalCode: "12571"
      }
    }
  }

  res = RestClient.put(
    "https://api.sandbox.ebay.com/sell/inventory/v1/inventory_item/test-1234567890",
    inventory_item_body.to_json,
    HEADERS
  )

  puts "Inventory item created: #{res.code}"
rescue RestClient::ExceptionWithResponse => e
  puts "Inventory item failed: #{e.response}"
end

# create offer - necessary for ebay
begin
  offer_body = {
    sku: 'test-1234567890',
    marketplaceId: "EBAY_US",
    format: "FIXED_PRICE",
    listingDescription: "test listing",
    availableQuantity: 1,
    pricingSummary: {
      price: { value: "9.99", currency: "USD" }
    },
    listingPolicies: {
      paymentPolicyId: PAYMENT_POLICY_ID,
      returnPolicyId: RETURN_POLICY_ID,
      fulfillmentPolicyId: FULFILLMENT_POLICY_ID
    },
    merchantLocationKey: "1",
    listing: {
      marketplaceId: "EBAY_US",
      condition: "1000",
      categoryId: '261716',
      location: {
        country: "US",
        postalCode: "12571",
      }
    }
  }

  res = RestClient.post(
    "https://api.sandbox.ebay.com/sell/inventory/v1/offer",
    offer_body.to_json,
    HEADERS
  )

  offer_id = JSON.parse(res.body)["offerId"]
  puts "Offer created: #{offer_id}"
rescue RestClient::ExceptionWithResponse => e
  puts "Offer creation failed: #{e.response}"
end

# publish offer
begin
  res = RestClient.post(
    "https://api.sandbox.ebay.com/sell/inventory/v1/offer/#{offer_id}/publish",
    nil,
    HEADERS
  )
  puts "Offer published: #{res.code}"
rescue RestClient::ExceptionWithResponse => e
  puts "Publish failed: #{e.response}"
end