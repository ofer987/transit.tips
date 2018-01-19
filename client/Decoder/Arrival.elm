module Decoder.Arrival exposing (arrival)

import Json.Decode as Json exposing (decodeString, int, float, string, nullable, list, at, field, Decoder)
import Decoder.Direction exposing (direction)
import Json.Arrival as Arrival exposing (Arrival)


arrival : Decoder Arrival
arrival =
    Json.map2
        Arrival
        (field "minutes" int)
        (field "direction" direction)
