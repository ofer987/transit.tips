module Init exposing (init)

import Task
import Platform.Cmd
import Model exposing (..)
import Model.Nearby


init : ( Location, Cmd Controller )
init =
    let
        arguments =
            newArguments

        model =
            NearbyModel arguments Model.Nearby.Nil

        cmd =
            Model.Nearby.GetLocation
                |> Task.succeed
                |> Task.perform (Nearby arguments Model.Nearby.Nil)
                |> Platform.Cmd.map Process
    in
        ( model, cmd )
