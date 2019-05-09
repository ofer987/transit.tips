module Json.Convert exposing (toModel)

import Json exposing (..)
import Model
import List


toModel : Schedule -> Model.Schedule
toModel =
    toSchedule


toSchedule : Schedule -> Model.Schedule
toSchedule json =
    Model.Schedule
        (Model.Location json.latitude json.longitude)
        (Model.Lines json.lines)


toLine : Line -> Model.Route
toLine json =
    Model.Line
        json.id
        ""
        (List.map toStation json.events)


toStation : Event -> Model.Station
toStation json =
    Model.Station
        json.station_id
        json.station
        (Model.Location json.longitude json.latitude)
        json.destination_station
        (List.map toEvent toEvents)


toEvent : Event -> Model.Event
toEvent json =
    Model.Event
        ""
        json.precisely_in
        json.message
