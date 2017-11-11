module Init exposing (init)

import Model exposing (..)


init : Model
init =
    { locationX = 0
    , locationY = 0
    , schedule =
        { routes = [] }
    }
