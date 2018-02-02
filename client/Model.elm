module Model exposing (..)

import Model.Nearby as Nearby
import Model.Search as Search


type Controller
    = NearbyController
    | SearchController String
    | Process Msg


type Msg
    = Nearby Nearby.Model Nearby.Msg
    | Search Search.Model Search.Msg


type Model
    = Nil
    | NearbyModel Nearby.Model
    | SearchModel Search.Model
