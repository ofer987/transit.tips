module Model exposing (..)

import Model.Location as Location
import Model.Nearby as Nearby
import Model.Search as Search


type Controller
    = Location
    | Nearby
    | Search

type ControllerMsg
    = Controller
    | LocationController Location.Msg
    | NearbyController Nearby.Msg
    | SearchController Search.Msg


type alias Model =
    { location : Location.Model
    , nearby : Nearby.Model
    , search : Search.Model
    }
