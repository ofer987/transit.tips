module RestBus.Decoder exposing (model)

import Json.Decode as Json exposing (decodeString, int, float, string, nullable, list, at, field, Decoder)
import Model.Nearby as Nearby exposing (Nearby)
import Model.Schedule as Schedule exposing (Schedule)
import Model.Route as Route exposing (Route)
import Model.Arrival as Arrival exposing (Arrival)


model : Decoder Nearby
model =
    Json.map4
        Nearby
        (field "latitude" float)
        (field "longitude" float)
        (field "schedule" schedule)
        (field "address" (nullable string))


schedule : Decoder Schedule
schedule =
    Json.map Schedule (list route)


route : Decoder Route
route =
    Json.map4
        Route
        (at [ "route", "id" ] string)
        (at [ "route", "title" ] string)
        (field "values" (list arrival))
        (at [ "stop", "title" ] string)


arrival : Decoder Arrival
arrival =
    Json.map2
        Arrival
        (at [ "direction", "title" ] string)
        (field "minutes" int)
