FactoryGirl.define do
  factory :status do
    tweet_id { SecureRandom.random_number(99999999) }
    line_id 7
    line_type 'Bus'
    description '7 Bathurst route bypassing East York Acres stop, until the end of service, due to inclement road conditions. #TTC'
    tweeted_at DateTime.new(2016, 1, 1)
  end
end
