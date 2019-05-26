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


type alias Model =
    { inputs : Input
    , results : Results
    }


type alias Input =
    { agencyIds : List String
    , routeId : String
    , location : Location
    }


type Results
    = Nil
    | DisplayNearby Nearby.Model
    | DisplaySearch Search.Model


emptyInput : Input
emptyInput =
    Input [] "" (Location 0.0 0.0)
