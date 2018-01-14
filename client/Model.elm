module Model exposing (..)

import Model.Nearby as Nearby
import Model.SearchResults as SearchResults


type ControllerMsg
    = NearbyController Nearby.Msg
    | SearchController SearchResults.Msg


type alias Model =
    { nearby : Nearby.Model
    , search : SearchResults.Model
    }
