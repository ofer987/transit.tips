module Decoder.Stop exposing (stop)

import Json.Decode as Json exposing (decodeString, int, float, string, nullable, list, at, field, Decoder)
import Model.Stop as Stop exposing (Stop)


stop : Decoder Stop
stop =
    Json.map5
        Stop
        (field "id" string)
        (field "code" string)
        (field "title" string)
        (field "latitude" float)
        (field "longitude" float)
