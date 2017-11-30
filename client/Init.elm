module Init exposing (init)

import Task
import Model exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        model =
            { location = Nothing
            , schedule = Nothing
            , error = Nothing
            }

        cmd =
            Task.succeed 42
                |> Task.perform GetLocation
    in
        ( model, cmd )
