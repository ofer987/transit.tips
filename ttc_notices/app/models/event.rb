class Event < ActiveRecord::Base
  belongs_to :calendar
  belongs_to :ttc_closure
end
