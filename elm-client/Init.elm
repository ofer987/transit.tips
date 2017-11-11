module Init exposing (init)

import Task
import Model exposing (..)


init : ( Model, Cmd Msg )
init =
    ( { locationLatitude = 0.0
      , locationLongitude = 0.0
      , schedule =
            { routes = [] }
      }
    -- TODO: How to ignore 42?
    , Task.perform GetLocation (Task.succeed 42)
    )
