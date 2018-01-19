module Decoder.Route exposing (route)

import Json.Decode as Json exposing (decodeString, int, float, string, nullable, list, at, field, Decoder)
import Json.Route as Route exposing (Route, Agency)
import Decoder.Agency exposing (agency)
import Decoder.Arrival exposing (arrival)


route : Decoder Route
route =
    Json.map5
        Route
        (at [ "route", "id" ] string)
        (at [ "route", "title" ] string)
        (at [ "agency", "id" ] (agency string))
        (field "stop" stop)
        (field "values" (list arrival))
