module Json.Decoder exposing (..)

import Json.Decode as Json exposing (Decoder, field, at, maybe, string, float, int, list, succeed, oneOf, null)
import Json exposing (..)


schedule : Float -> Float -> Decoder Schedule
schedule latitude longitude =
    Json.map4
        Schedule
        (succeed latitude)
        (succeed longitude)
        (succeed Nothing)
        (list line)


line : Decoder Line
line =
    Json.map5
        Line
        (at [ "line", "id" ] int)
        (at [ "line", "name" ] string)
        (at [ "agency", "id" ] string)
        (field "stations" (list station))


station : Decoder Station
station =
    json.map5
        Station
        (at [ "station", "id" ] int)
        (at [ "station", "name" ] string)
        (at [ "station", "latitude" ] float)
        (at [ "station", "longitude" ] float)
        (at [ "station", "directions" ] (list direction))


direction : Decoder Direction
direction =
    Json.map2
        Direction
        (at [ "destination_station" ] string)
        (at [ "events" ] (list event))


event : Decoder Event
event =
    Json.map3
        Event
        (at [ "event", "approximately_in" ] string)
        (at [ "event", "precisely_in" ] float)
        (at [ "event", "message" ] string)
