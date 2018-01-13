module Decoder.Schedule exposing (schedule)

import Json.Decode as Json exposing (decodeString, int, float, string, nullable, list, at, field, Decoder)
import Model.Schedule as Schedule exposing (Schedule)
import Decoder.Route exposing (route)


schedule : Decoder Schedule
schedule =
    Json.map Schedule (list route)
