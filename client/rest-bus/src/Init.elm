module Init exposing (init)

import Task
import Platform.Cmd
import Model exposing (..)
import Model.Nearby


init : ( Location, Cmd Controller )
init location =
    let
        arguments =
            {}

        model =
            NearbyModel arguments (Model.HasLocation location)

        msg =
            Nearby arguments model RequestSchedule

        nearbyCmd =
            location
                |> Task.succeed
                |> Task.perform msg

        cmd =
            nearbyCmd
                |> Platform.Cmd.map Process
    in
        ( model, cmd )
