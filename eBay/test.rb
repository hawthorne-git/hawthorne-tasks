require 'rest-client'
require 'json'

TOKEN = 'v^1.1#i^1#f^0#p^3#I^3#r^0#t^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'
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
        "Storage Capacity": ["64 GB"],
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
    "https://api.sandbox.ebay.com/sell/inventory/v1/inventory_item/test-123456666",
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
    sku: 'test-123456666',
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