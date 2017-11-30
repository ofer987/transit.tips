module RestBus.Decoder exposing (schedule)

import Json.Decode as Json exposing (decodeString, int, string, list, at, field, Decoder)
import Model.Schedule as Schedule exposing (Schedule)
import Model.Route as Route exposing (Route)
import Model.Arrival as Arrival exposing (Arrival)


schedule : Decoder Schedule
schedule =
    Json.map Schedule (list route)


route : Decoder Route
route =
    Json.map3
        Route
        (at [ "route", "id" ] string)
        (at [ "route", "title" ] string)
        (field "values" (list arrival))


arrival : Decoder Arrival
arrival =
    Json.map2
        Arrival
        (at [ "direction", "title" ] string)
        (field "minutes" int)
