module Decoder.MyDirection exposing (myDirection)

import Json.Decode as Json exposing (decodeString, int, float, string, nullable, list, at, field, Decoder)
import Model.Route exposing (MyDirection)


myDirection : Decoder MyDirection
myDirection =
    Json.map4
        MyDirection
        (field "id" string)
        (field "shortTitle" string)
        (field "title" string)
        (field "stops" (list string))
