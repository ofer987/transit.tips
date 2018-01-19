module Decoder.Direction exposing (..)

import Json.Decode as Json exposing (decodeString, oneOf, null, int, float, string, nullable, list, at, field, Decoder)
import Json.Direction exposing (Direction)

direction : Decoder Direction
direction =
    Json.map2
        Direction
        (field "id" (oneOf [ string, null "" ]))
        (field "title" string)
