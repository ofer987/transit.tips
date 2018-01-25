module Init exposing (init)

import Task
import Model exposing (..)
import Model.Nearby
import Model.Search


init : ( Model, Cmd ControllerMsg )
init =
    let
        model =
            { nearby = Model.Nearby.NoLocation
            , search = Model.Search.NoLocation
            }

        cmd =
            Task.succeed (Model.Nearby.GetLocation 42)
                |> Task.perform NearbyController
    in
        ( model, cmd )
