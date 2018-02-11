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
    = Nearby Arguments Nearby.Model Nearby.Msg
    | Search Arguments Search.Model Search.Msg


type Model
    = Nil
    | NearbyModel Arguments Nearby.Model
    | SearchModel Arguments Search.Model
