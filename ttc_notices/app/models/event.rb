class Event < ActiveRecord::Base
  belongs_to :calendar
  belongs_to :ttc_closure, foreign_key: 'ttc_closure_id'
end
