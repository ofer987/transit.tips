module Json.Decoder exposing (model)

import Json.Decode as Json exposing (Decoder, field, at, maybe, string, float, int, list, succeed, oneOf, null)
import Json exposing (..)


model : Float -> Float -> Decoder Schedule
model =
    schedule


schedule : Float -> Float -> Decoder Schedule
schedule latitude longitude =
    Json.map3
        Schedule
        (succeed latitude)
        (succeed longitude)
        (list line)


line : Decoder Line
line =
    Json.map3
        Line
        (field "id" int)
        (field "name" string)
        (field "stations" (list station))


station : Decoder Station
station =
    Json.map5
        Station
        (field "id" int)
        (field "name" string)
        (field "latitude" float)
        (field "longitude" float)
        (field "directions" (list direction))


direction : Decoder Direction
direction =
    Json.map2
        Direction
        (field "destination_station" string)
        (field "events" (list event))


event : Decoder Event
event =
    Json.map3
        Event
        (field "approximately_in" string)
        (field "precisely_in" float)
        (field "message" string)
