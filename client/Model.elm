module Model exposing (..)

import Model.Nearby as Nearby
import Model.Search as Search
import Model.Search.Arguments exposing (Arguments)


type Controller
    = NearbyController
    | SearchController String
    | UpdateArguments Arguments
    | Process Msg


type Msg
    = Nearby Nearby.Model Nearby.Msg
    | Search Search.Model Search.Msg


type Model
    = Nil
    | NearbyModel Arguments Nearby.Model
    | SearchModel Arguments Search.Model
