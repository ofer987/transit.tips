module Model exposing (..)

import Model.Nearby as Nearby
import Model.Search as Search


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


type alias Arguments =
    { agencyIds : List String
    , routeId : String
    }


newArguments : Arguments
newArguments =
    Arguments [] ""
