module Decoder.Common exposing (agency, toAgency)

import Json.Decode as Json exposing (decodeString, int, float, string, nullable, list, at, field, Decoder)
import Json.Common exposing (Agency(..))


agency : Decoder String -> Decoder Agency
agency value =
    Json.map toAgency value


toAgency : String -> Agency
toAgency value =
    let
        lowerAndTrimmed =
            value
                |> String.trim
                |> String.toLower
    in
        if lowerAndTrimmed == "ttc" then
            TTC
        else
            Other
