module Init exposing (init)

import Task
import Platform.Cmd
import Model exposing (..)
import Model.Common exposing (Location)
import Model.Nearby
import Model.Search


init : Location -> ( Model, Cmd Msg )
init location =
    let
        model =
            { inputs = { emptyInput | location = location }
            , results = DisplayNearby (Model.Nearby.HasLocation location)
            }

        --
        -- msg =
        --     Nearby arguments model (RequestSchedule location)
        cmd =
            Model.Nearby.RequestSchedule location
                |> Task.succeed
                |> Task.perform Nearby
                |> Platform.Cmd.map Process
    in
        ( model, cmd )
