FactoryGirl.define do
  factory :event do
    google_event_id SecureRandom.uuid
    name "MyString"
    description "MyText"
  end
end
