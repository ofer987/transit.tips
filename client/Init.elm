module Init exposing (init)

import Task
import Platform.Cmd
import Model exposing (..)
import Model.Search.Arguments exposing (Arguments, newArguments)
import Model.Nearby


init : ( Model, Cmd Controller )
init =
    let
        model =
            NearbyModel newArguments Model.Nearby.Nil

        cmd =
            Task.succeed Model.Nearby.GetLocation
                |> Task.perform (Nearby Model.Nearby.Nil)
                |> Platform.Cmd.map Process
    in
        ( model, cmd )
