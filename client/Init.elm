module Init exposing (init)

import Task
import Model exposing (..)
import Model.Location as Location
import Model.Nearby as Nearby
import Model.Search as Search


init : ( Model, Cmd ControllerMsg )
init =
    let
        model =
            { location = Location.Nil
            , nearby = Nearby.Nil
            , search = Search.Nil
            }

        cmd =
            Task.succeed (Location.GetLocation 42)
                |> Task.perform LocationController
    in
        ( model, cmd )
