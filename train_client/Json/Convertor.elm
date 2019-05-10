module Json.Convertor exposing (toModel)

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
        (List.map toLine json.lines)


toLine : Line -> Model.Line
toLine json =
    Model.Line
        json.id
        json.name
        (List.map toStation json.events)


toStation : Station -> Model.Station
toStation json =
    Model.Station
        json.id
        json.name
        (Model.Location json.latitude json.longitude)
        json.destination_station
        (List.map toDirection toDirection)


toDirection : Direction -> Model.Direction
toDirection json =
    Model.Direction
        json.destination_station
        (List.map toEvent json.events)


toEvent : Event -> Model.Event
toEvent json =
    Model.Event
        json.approximately_in
        json.precisely_in
        json.message
