module Init exposing (init)

import Task
import Model exposing (..)


init : ( Model, Cmd Msg )
init =
    let
        model =
            NoLocation

        cmd =
            Task.succeed 42
                |> Task.perform GetLocation
    in
        ( model, cmd )
