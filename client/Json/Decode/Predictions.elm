module Json.Decode.Predictions exposing (nearby, schedule, route, direction, stop, arrival)

import Json.Decode as Json exposing (Decoder, field, at, string, float, int, list, succeed, oneOf, null, maybe)
import Json.Predictions exposing (Schedule, Route, Direction, Stop, Arrival)

nearby : Decoder Schedule
nearby =
    Json.map4
    Schedule
    (field "latitude" float)
    (field "longitude" float)
    (field "address" (maybe string))
    (field "routes" (list route))

schedule : Float -> Float -> Decoder Schedule
schedule latitude longitude =
    Json.map4
        Schedule
        (succeed latitude)
        (succeed longitude)
        (succeed Nothing)
        (list route)


route : Decoder Route
route =
    Json.map5
        Route
        (at [ "route", "id" ] string)
        (at [ "route", "title" ] string)
        (at [ "agency", "id" ] string)
        (field "stop" stop)
        (field "values" (list arrival))


direction : Decoder Direction
direction =
    Json.map2
        Direction
        (field "id" string)
        (field "title" string)


stop : Decoder Stop
stop =
    Json.map2
        Stop
        (field "id" string)
        (field "title" string)


arrival : Decoder Arrival
arrival =
    Json.map3
        Arrival
        (field "minutes" int)
        (field "seconds" int)
        (field "direction" direction)
