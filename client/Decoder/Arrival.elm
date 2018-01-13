module Decoder.Arrival exposing (arrival)

import Json.Decode as Json exposing (decodeString, int, float, string, nullable, list, at, field, Decoder)
import Model.Arrival as Arrival exposing (Arrival)


arrival : Decoder Arrival
arrival =
    Json.map2
        Arrival
        (at [ "direction", "title" ] string)
        (field "minutes" int)
