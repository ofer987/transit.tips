module Model exposing (..)

import Model.Location as Location
import Model.Nearby as Nearby
import Model.Search as Search


type ControllerMsg
    = LocationController Location.Msg
    | NearbyController Nearby.Msg
    | SearchController Search.Msg


type alias Model =
    { location : Location.Model
    , nearby : Nearby.Model
    , search : Search.Model
    }
