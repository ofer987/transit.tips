module Decoder.Nearby exposing (nearby)

import Json.Decode as Json exposing (decodeString, int, float, string, nullable, list, at, field, Decoder)
import Model.Nearby as Nearby exposing (Nearby)
import Decoder.Schedule exposing (schedule)


nearby : Decoder Nearby
nearby =
    Json.map4
        Nearby
        (field "latitude" float)
        (field "longitude" float)
        (field "schedule" schedule)
        (field "address" (nullable string))
