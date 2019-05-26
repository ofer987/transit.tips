module Init exposing (init)

import Task
import Platform.Cmd
import Model exposing (..)
import Model.Common exposing (Location)
import Model.Nearby


init : Location -> ( Model, Cmd Controller )
init location =
    let
        arguments =
            newArguments

        model =
            NearbyModel arguments (Model.Nearby.HasLocation location)

        --
        -- msg =
        --     Nearby arguments model (RequestSchedule location)
        cmd =
            Model.Nearby.RequestSchedule location
                |> Task.succeed
                |> Task.perform (Nearby arguments (Model.Nearby.HasLocation location))
                |> Platform.Cmd.map Process
    in
        ( model, cmd )
