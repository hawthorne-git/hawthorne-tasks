require 'google/ads/google_ads'

customer_id = 'customer_id'

client = Google::Ads::GoogleAds::GoogleAdsClient.new do |config|
  config.client_id = 'client_id'
  config.client_secret = 'client_secret'
  config.refresh_token = CGI.unescape('refresh_token')
  config.developer_token = 'developer_token'
end

if false
  assets = [
    client.resource.asset do |asset|
      asset.sitelink_asset = client.resource.sitelink_asset do |sitelink|
        sitelink.description1 = "Get in touch"
        sitelink.description2 = "Find your local store"
        sitelink.link_text = "Store locator"
      end
      asset.final_urls << "http://example.com/contact/store-finder"
      asset.final_mobile_urls << "http://example.com/mobile/contact/store-finder"
    end,
    client.resource.asset do |asset|
      asset.sitelink_asset = client.resource.sitelink_asset do |sitelink|
        sitelink.description1 = "But some stuff"
        sitelink.description2 = "It's really good"
        sitelink.link_text = "Store"
      end
      asset.final_urls << "http://example.com/store"
      asset.final_mobile_urls << "http://example.com/mobile/store"
    end,
    client.resource.asset do |asset|
      asset.sitelink_asset = client.resource.sitelink_asset do |sitelink|
        sitelink.description1 = "Even more stuff"
        sitelink.description2 = "There's never enough"
        sitelink.link_text = "Store for more"
      end
      asset.final_urls << "http://example.com/store/more"
      asset.final_mobile_urls << "http://example.com/mobile/store/more"
    end,
  ]

  operations = assets.map do |asset|
    client.operation.create_resource.asset(asset)
  end

  response = client.service.asset.mutate_assets(
    customer_id: customer_id,
    operations: operations,
  )

  response.results.map do |result|
    puts "Created sitelink asset with resource name #{result.resource_name}"
    result.resource_name
  end

  # Created sitelink asset with resource name customers/3787416429/assets/62672014435
  # Created sitelink asset with resource name customers/3787416429/assets/62672014438
  # Created sitelink asset with resource name customers/3787416429/assets/62672014441
end

resource_names = ['customers/3787416429/assets/62672014438']

if false
  operations = resource_names.map do |resource_name|
    client.operation.create_resource.campaign_asset do |ca|
      ca.asset = resource_name
      ca.campaign = client.path.campaign(customer_id, '18952550592')
      ca.field_type = :SITELINK
    end
  end

  response = client.service.campaign_asset.mutate_campaign_assets(
    customer_id: customer_id,
    operations: operations,
    )

  response.results.each do |result|
    puts "Created campaign asset with resource name #{result.resource_name}."
  end

  # Created campaign asset with resource name customers/3787416429/campaignAssets/18952550592~62672014435~SITELINK.
end

if false
  operations = resource_names.map do |resource_name|
    client.operation.create_resource.ad_group_asset do |ag|
      ag.asset = resource_name
      ag.ad_group = client.path.ad_group(customer_id, '144136060255')
      ag.field_type = :SITELINK
    end
  end

  response = client.service.ad_group_asset.mutate_ad_group_assets(
    customer_id: customer_id,
    operations: operations,
    )

  response.results.each do |result|
    puts "Created ad group asset with resource name #{result.resource_name}."
  end
  # Created ad group asset with resource name customers/3787416429/adGroupAssets/144136060255~62672014438~SITELINK.
end

if true
  ad_group_asset_resource = client.path.ad_group_asset(customer_id, '144136060255', '62672014438', :SITELINK)
  puts ad_group_asset_resource.to_s
  operation = client.operation.update_resource.ad_group_asset(ad_group_asset_resource) do |ag|
    ag.status = :PAUSED
  end
  client.service.ad_group_asset.mutate_ad_group_assets(customer_id: customer_id, operations: [operation],)
end

if false
  responses = client.service.google_ads.search_stream(
    customer_id: '3787416429',
    query: "SELECT ad_group_asset.asset FROM ad_group_asset"
  )
  puts responses.first.to_s
  responses.each do |response|
    response.results.each do |row|
      row.to_s
    end
  end
end

puts 'DONE!'