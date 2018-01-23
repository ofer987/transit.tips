module Decoder.Predictions exposing (route, direction, stop, arrival)

import Json.Decode as Json exposing (Decoder, field, at, string, float, int, list, succeed, oneOf, null)
import Decoder.Common exposing (agency, toAgency)
import Json.Predictions exposing (Route, Direction, Stop, Arrival)


route : Decoder Route
route =
    Json.map5
        Route
        (at [ "route", "id" ] string)
        (at [ "route", "title" ] string)
        (at [ "agency", "id" ] (agency string))
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
