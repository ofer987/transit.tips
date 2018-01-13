module Decoder.Agency exposing (agency)

import Json.Decode as Json exposing (decodeString, int, float, string, nullable, list, at, field, Decoder)
import Model.Route as Route exposing (Route, Agency)


agency : Decoder String -> Decoder Agency
agency value =
    Json.map Route.toAgency value
