module Decoder.Nearby exposing (nearby)

import Json.Decode as Json exposing (decodeString, int, float, string, nullable, list, at, field, Decoder)
import Json.Nearby as Nearby exposing (Nearby)
import Model.Nearby
import Decoder.Schedule exposing (schedule)

-- map the json value to a model value

nearby : Decoder Nearby
nearby =
    Json.map4
        Nearby
        (field "latitude" float)
        (field "longitude" float)
        (field "schedule" schedule)
        (field "address" (nullable string))
