module Decoder.Route exposing (route)

import Json.Decode as Json exposing (decodeString, int, float, string, nullable, list, at, field, Decoder)
import Model.Route as Route exposing (Route, Agency)
import Decoder.Agency exposing (agency)
import Decoder.Arrival exposing (arrival)


route : Decoder Route
route =
    Json.map5
        Route
        (at [ "route", "id" ] string)
        (at [ "route", "title" ] string)
        (field "values" (list arrival))
        (at [ "stop", "title" ] string)
        (at [ "agency", "id" ] (agency string))
