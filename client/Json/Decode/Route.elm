module Json.Decode.Route exposing (nearby, route, direction, stop)

import Json.Decode as Json exposing (Decoder, field, at, string, float, list, succeed, oneOf, null)
import Json.Decode.Common exposing (agency, toAgency)
import Json.Route exposing (Route, Direction, Stop)


schedule : Float -> Float -> String -> Decoder Schedule
schedule latitude longitude agencyId =
    Json.map4
        Schedule
        (succeed latitude)
        (succeed longitude)
        (succeed Nothing)
        (field "routes" (list (route agencyId)))


route : String -> Decoder Route
route agencyId =
    Json.map5
        Route
        (field "id" string)
        (field "title" string)
        (succeed (toAgency agencyId))
        (field "stops" (list stop))
        (field "directions" (list direction))


direction : Decoder Direction
direction =
    Json.map4
        Direction
        (field "id" string)
        (field "title" string)
        (field "shortTitle" (oneOf [ string, null "" ]))
        (field "stops" (list string))


stop : Decoder Stop
stop =
    Json.map5
        Stop
        (field "id" string)
        (field "code" string)
        (field "title" string)
        (field "lat" float)
        (field "lon" float)
