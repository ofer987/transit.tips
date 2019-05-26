module Model exposing (..)

import Model.Common exposing (Location)
import Model.Nearby as Nearby
import Model.Search as Search


type Msg
    = InitialNearby
    | InitialSearch (List String) String
    | Update Input
    | Process Workflow


type Workflow
    = Nearby Nearby.Msg
    | Search Search.Msg


type Model
    = Nil
    | NearbyModel Input Nearby.Model
    | SearchModel Input Search.Model


type alias Input =
    { agencyIds : List String
    , routeId : String
    , location : Location
    }


emptyInput : Input
emptyInput =
    Input [] "" (Location 0.0 0.0)
