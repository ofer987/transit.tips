module Decoder.SearchResults exposing (searchResults)

import Json.Decode as Json exposing (map, decodeString, int, float, string, nullable, list, at, field, Decoder)
import Decoder.Route exposing (route)
import Model.Route as Route exposing (Route, Agency(..))
import List


searchResults : Decoder (Maybe Route)
searchResults =
    map List.head (list route)
