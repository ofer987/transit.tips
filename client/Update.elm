module Update exposing (update)

import Model exposing (..)
import Model.Nearby
import Model.Search
import Update.Nearby
import Update.Search
import Task
import Tuple
import Platform.Cmd


update : Controller -> Model -> ( Model, Cmd Controller )
update controller model =
    case controller of
        NearbyController ->
            let
                nextCmd =
                    Task.succeed Model.Nearby.GetLocation
                        |> Task.perform (Nearby Model.Nearby.Nil)
                        |> Platform.Cmd.map Process

                -- nextCmd =
                --     Task.succeed (Nearby Model.Nearby.Nil Model.Nearby.GetLocation)
                --         |> Task.perform Process
                nextModel =
                    NearbyModel Model.Nearby.Nil
            in
                ( nextModel, nextCmd )

        SearchController routeId ->
            let
                nextCmd =
                    Task.succeed (Model.Search.GetLocation routeId)
                        |> Task.perform (Search (Model.Search.Nil routeId))
                        |> Platform.Cmd.map Process

                -- nextCmd =
                --     Task.succeed (Search (Model.Search.Nil routeId) (Model.Search.GetLocation routeId))
                --         |> Task.perform Process
                nextModel =
                    SearchModel (Model.Search.Nil routeId)
            in
                ( nextModel, nextCmd )

        -- let
        --     result =
        --         Update.Nearby.update msg model.nearby
        --
        --     nextModel =
        --         { model | nearby = Tuple.first result }
        --
        --     nextCmd =
        --         Tuple.second result
        --             |> Platform.Cmd.map NearbyController
        -- in
        --     ( nextModel, nextCmd )
        Process (Nearby model msg) ->
            let
                result =
                    Update.Nearby.update msg model

                nextModel =
                    NearbyModel (Tuple.first result)

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map (Nearby (Tuple.first result))
                        |> Platform.Cmd.map Process
            in
                ( nextModel, nextCmd )

        Process (Search model msg) ->
            let
                result =
                    Update.Search.update msg model

                nextModel =
                    SearchModel (Tuple.first result)

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map (Search (Tuple.first result))
                        |> Platform.Cmd.map Process
            in
                ( nextModel, nextCmd )
