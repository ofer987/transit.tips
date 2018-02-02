module Init exposing (init)

import Task
import Model exposing (..)
import Model.Nearby as Nearby
import Update exposing (..)
import Update.Nearby


init : ( Model, Cmd Controller )
init =
    let
        model =
            Nearby.Nil

        cmd =
            Task.succeed (Nearby.GetLocation)
                |> Task.perform NearbyController
    in
        ( model, cmd )
