module Model exposing (..)

import Model.Common exposing (Location)
import Model.Nearby as Nearby
import Model.Search as Search


type Controller
    = NearbyController
    | SearchController (List String) String
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
    , location : Location
    }



-- TODO: create a new model that stores all data in it


newArguments : Arguments
newArguments =
    Arguments [] "" (Location 0.0 0.0)
