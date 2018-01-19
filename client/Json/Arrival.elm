module Json.Arrival exposing (..)

import Json.Direction exposing (Direction)


type alias Arrival =
    { time : Int
    , direction : Direction
    }
