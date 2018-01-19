module Model.Direction exposing (..)

import Model.Stop exposing (Stop)

type alias Direction =
    { id : String
    , shortTitle : String
    , title : String
    , stops : List Stop
    }
