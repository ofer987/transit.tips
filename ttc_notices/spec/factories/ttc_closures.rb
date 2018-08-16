FactoryGirl.define do
  factory :finch_to_sheppard_closure, class: Ttc::Closure do
    line_id 1
    from_station_name "Finch"
    to_station_name "Sheppard"
    start_at "2018-07-20 15:23:58"
    end_at "2018-07-28 15:23:58"
  end

  factory :lawrence_to_st_clair, class: Ttc::Closure do
    line_id 1
    from_station_name "Lawrence"
    to_station_name "Saint Clair"
    start_at "2018-07-22 15:23:58"
    end_at "2018-07-26 15:23:58"
  end

  factory :invalid_closure, class: Ttc::Closure do
    line_id 1
    from_station_name nil
    to_station_name "Sheppard"
    start_at "2018-07-20 15:23:58"
    end_at "2018-07-28 15:23:58"
  end
end
