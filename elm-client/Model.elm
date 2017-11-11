module Model exposing (..)

import Model.Schedule exposing (..)


type Msg
    = None


type alias Model =
    { locationX : Float
    , locationY : Float
    , schedule : Schedule
    }
