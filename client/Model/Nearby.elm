module Model.Nearby exposing (Nearby)

import Model.Schedule as Schedule exposing (Schedule)


type alias Nearby =
    { latitude : Float
    , longitude : Float
    , schedule : Schedule
    , address : String
    }
