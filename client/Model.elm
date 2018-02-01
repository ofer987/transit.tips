module Model exposing (..)

import Model.Location as Location
import Model.Nearby as Nearby
import Model.Search as Search


type ControllerMsg
    = Nearby
    | Search String
    | DoLocation Controller Location.Msg
    | DoNearby Nearby.Msg
    | DoSearch

type Controller
    = NearbyController
    | SearchController


type alias Model =
    { location : Location.Model
    , nearby : Nearby.Model
    , search : Search.Model
    }
