module Model.Response exposing (Response)

import Model.Schedule as Schedule exposing (Schedule)


type alias Response =
    { latitude : Float
    , longitude : Float
    , schedule : Schedule
    }
