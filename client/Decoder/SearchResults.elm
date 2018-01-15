module Decoder.SearchResults exposing (searchResults)

import Json.Decode as Json exposing (map, decodeString, int, float, string, nullable, list, at, field, Decoder)
import Decoder.Route exposing (route)
import Model.Route as Route exposing (Route, Agency(..))
import List
import Maybe


searchResults : Decoder Route
searchResults =
    list route
        |> map firstRoute


firstRoute : List Route -> Route
firstRoute routes =
    routes
        |> List.head
        |> Maybe.withDefault nilRoute


nilRoute : Route
nilRoute =
    { id = ""
    , title = ""
    , arrivals = []
    , location = ""
    , agency = Other
    }
