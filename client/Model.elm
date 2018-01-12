module Model exposing (..)

import Model.Nearby as Nearby
import Model.SearchResults as SearchResults


type ControllerMsg
    = None
    | Nearby Nearby.Model
    | Search SearchResults.Model


type alias Model =
    { nearby : Nearby.Model
    , search : SearchResults.Model
    }
