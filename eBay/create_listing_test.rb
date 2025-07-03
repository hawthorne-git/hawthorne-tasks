require 'rest-client'
require 'json'

TOKEN = 'v^1.1#i^1#f^0#r^0#I^3#p^3#t^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'
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
      aspects: {
        Brand: ["HSCO"],
        Model: ["Test Model"],
        "Storage Capacity": ["128 GB"],
        Color: ["Black"]
      },
      imageUrls: ["https://hawthorne-s3-bucket.s3.us-east-2.amazonaws.com/static-image-assets/Logo+FINAL+WEBP.webp"],
      category: { categoryId: "15687" }
    },
    availability: {
      shipToLocationAvailability: {
        quantity: 1
      }
    },
    condition: 'NEW',
    packageWeightAndSize: {
      dimensions: {
        length: 10,
        width: 6,
        height: 2,
        unit: "INCH"
      },
      weight: {
        value: 2,
        unit: "POUND"
      }
    },
    categoryId: '9355',
    merchantLocationKey: "1",
    listing: {
      marketplaceId: "EBAY_US",
      location: {
        country: "US",
        postalCode: "95008"
      }
    }
  }

  res = RestClient.put(
    "https://api.sandbox.ebay.com/sell/inventory/v1/inventory_item/test-12345666678",
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
    sku: 'test-12345666678',
    marketplaceId: "EBAY_US",
    format: "FIXED_PRICE",
    listingDescription: "test listing",
    availableQuantity: 1,
    categoryId: '9355',
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
      condition: "NEW",
      location: {
        country: "US",
        postalCode: "95008"
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