class Event < ActiveRecord::Base
  # google_event_id, NVARCHAR, NOT NULL
  # calendar_id, INTEGER, INDEX, FOREIGN KEY, NOT NULL
  # ttc_closure_id, INTEGER, INDEX, FOREIGN KEY, NOT NULL
  # name, NVARCHAR, NOT NULL
  # description, TEXT, NOT NULL, DEFAULT: ''

  belongs_to :calendar
  belongs_to :ttc_closure, foreign_key: 'ttc_closure_id', class_name: Ttc::Closure

  def google_event
    calendar = Calendar.find(calendar_id)

    poller = Poller::TtcClosures.new(calendar, Time.zone.now)
    poller.get_event(google_event_id)
  end
end
