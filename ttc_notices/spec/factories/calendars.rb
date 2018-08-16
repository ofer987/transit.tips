FactoryGirl.define do
  factory :real_calendar, class: Calendar do
    google_calendar_id nil
    name 'Some Real Google Calendar'
  end

  factory :fake_calendar, class: Calendar do
    google_calendar_id 'Fake_id'
    name 'Some Fake Google Calendar'
  end
end
