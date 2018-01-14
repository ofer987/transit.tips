module Decoder.MyRoute exposing (myRoute)

import Json.Decode as Json exposing (decodeString, int, float, string, nullable, list, at, field, succeed, Decoder)
import Model.Route as Route exposing (MyRoute)
import Decoder.Stop exposing (stop)


myRoute : String -> Float -> Float -> Decoder MyRoute
myRoute agencyId latitude longitude =
    Json.map5
        MyRoute
        (field "id" string)
        (succeed agencyId)
        (field "stops" (list stop))
        (succeed latitude)
        (succeed longitude)
