module Update exposing (update)

import Model exposing (..)
import Update.Location
import Update.Nearby
import Update.Search
import Tuple
import Platform.Cmd


update : Controller -> Model -> ( Model, Cmd Controller )
update controller model =
    case controller of
        NearbyController ->
            let
                nextCmd =
                    Task.succeed Update.Nearby.GetLocation
                        |> Task.perform (NearbyModel Model.Nearby.Nil)

                nextModel =
                    NearbyModel Model.Nearby.Nil
            in
                ( nextModel, nextCmd )

        SearchController routeId ->
            let
                nextCmd =
                    Task.succeed (Update.Search.GetLocation routeId)
                        |> Task.perform (NearbyModel (Model.Search.Nil routeId))

                nextModel =
                    NearbyModel (Model.Search.Nil routeId)
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
                        |> Platform.Cmd.map (Nearby nextModel)
            in
                ( nextModel, Nearby nextModel nextCmd )

        Process (Search model msg) ->
            let
                result =
                    Update.Search.update msg model

                nextModel =
                    SearchModel (Tuple.first result)

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map (Search nextModel)
            in
                ( nextModel, Search nextModel nextCmd )
