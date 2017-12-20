module RestBus.Decoder exposing (model)

import Json.Decode as Json exposing (decodeString, int, float, string, list, at, field, Decoder)
import Model.Response as Response exposing (Response)
import Model.Schedule as Schedule exposing (Schedule)
import Model.Route as Route exposing (Route)
import Model.Arrival as Arrival exposing (Arrival)


model : Decoder Response
model =
    Json.map3
        Response
        (field "latitude" float)
        (field "longitude" float)
        (field "schedule" schedule)


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
