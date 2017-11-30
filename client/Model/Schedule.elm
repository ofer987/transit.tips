module Model.Schedule exposing (..)

import Model.Route as Route exposing (Route)


type alias Schedule =
    { routes : List Route
    }
