module Json.Convertor exposing (toModel)

import Json exposing (..)
import Model
import List


toModel : Schedule -> Model.Schedule
toModel =
    toSchedule


toSchedule : Schedule -> Model.Schedule
toSchedule json =
    let
        lineModels =
            json.lines
                |> List.map toLine
                |> List.filterMap identity
    in
        Model.Schedule
            (Model.Location json.latitude json.longitude)
            lineModels


toLine : Line -> Maybe Model.Line
toLine json =
    case List.head json.stations of
        Just station ->
            let
                stationModel =
                    Model.Line
                        json.id
                        json.name
                        (toStation station)
            in
                Just stationModel

        Nothing ->
            Nothing


toStation : Station -> Model.Station
toStation json =
    Model.Station
        json.id
        json.name
        (Model.Location json.latitude json.longitude)
        (List.map toDirection json.directions)


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
