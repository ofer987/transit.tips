module Model exposing (..)

import Model.Schedule exposing (..)


type Msg
    = None
    | SetLocation


type alias Model =
    { locationX : Float
    , locationY : Float
    , schedule : Schedule
    }
