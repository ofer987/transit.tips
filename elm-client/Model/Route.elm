module Model.Route exposing (..)

import Model.Arrival as Arrival exposing (Arrival)


type alias Route =
    { id : String
    , title : String
    , arrivals : List Arrival
    }
