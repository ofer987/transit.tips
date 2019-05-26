module Json.Decode.Route exposing (schedule, route, direction, stop)

import Json.Decode as Json exposing (Decoder, field, at, maybe, string, float, list, succeed, oneOf, null)
import Json.Route exposing (Schedule, Route, Direction, Stop)


schedule : Float -> Float -> String -> Decoder (List Schedule)
schedule latitude longitude agencyId =
    let
        item =
            Json.map4
                Schedule
                (succeed latitude)
                (succeed longitude)
                (succeed Nothing)
                (route agencyId)

        result =
            Json.list item
    in
        result


route : String -> Decoder Route
route agencyId =
    Json.map5
        Route
        (field "id" string)
        (field "title" string)
        (succeed agencyId)
        (field "stops" (list stop))
        (field "directions" (list direction))


direction : Decoder Direction
direction =
    Json.map4
        Direction
        (field "id" (maybe string))
        (field "title" string)
        (field "shortTitle" (oneOf [ string, null "" ]))
        (field "stops" (list string))


stop : Decoder Stop
stop =
    Json.map5
        Stop
        (field "id" string)
        (field "code" (oneOf [ string, null "" ]))
        (field "title" string)
        (field "lat" float)
        (field "lon" float)
