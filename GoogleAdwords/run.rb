require 'google/ads/google_ads'

customer_id = 'customer_id'

client = Google::Ads::GoogleAds::GoogleAdsClient.new do |config|
  config.client_id = 'client_id'
  config.client_secret = 'client_secret'
  config.refresh_token = CGI.unescape('refresh_token')
  config.developer_token = 'developer_token'
end

responses = client.service.google_ads.search_stream(
  customer_id: '3787416429',
  query: "SELECT click_view.ad_group_ad, click_view.gclid, click_view.keyword, click_view.keyword_info.match_type, click_view.keyword_info.text FROM click_view WHERE click_view.gclid = 'EAIaIQobChMIoN268eXK-wIVvhPUAR1euQqxEAAYASACEgKvTfD_BwE'"
)
puts responses.first.to_s
responses.each do |response|
  response.results.each do |row|
    row.to_s
  end
end

puts 'DONE!'