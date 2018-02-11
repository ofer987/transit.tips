module Update exposing (update)

import Model exposing (..)
import Model.Nearby
import Model.Search
import Model.Search.Arguments exposing (Arguments, newArguments)
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
                arguments =
                    newArguments

                nextCmd =
                    Task.succeed Model.Nearby.GetLocation
                        |> Task.perform (Nearby arguments Model.Nearby.Nil)
                        |> Platform.Cmd.map Process

                -- nextCmd =
                --     Task.succeed (Nearby Model.Nearby.Nil Model.Nearby.GetLocation)
                --         |> Task.perform Process
                nextModel =
                    NearbyModel arguments Model.Nearby.Nil
            in
                ( nextModel, nextCmd )

        -- Do nothing
        SearchController "" ->
            ( model, Cmd.none )

        SearchController routeId ->
            let
                nextCmd =
                    Task.succeed (Model.Search.GetLocation arguments.agencyIds arguments.routeId)
                        |> Task.perform (Search arguments Model.Search.Nil)
                        |> Platform.Cmd.map Process

                arguments =
                    case model of
                        Nil ->
                            newArguments

                        NearbyModel arguments_ _ ->
                            arguments_

                        SearchModel arguments_ _ ->
                            arguments_

                -- nextCmd =
                --     Task.succeed (Search (Model.Search.Nil routeId) (Model.Search.GetLocation routeId))
                --         |> Task.perform Process
                nextModel =
                    SearchModel arguments Model.Search.Nil
            in
                ( nextModel, nextCmd )

        UpdateArguments arguments ->
            let
                nextModel =
                    case model of
                        Nil ->
                            Nil

                        NearbyModel _ nearby ->
                            NearbyModel arguments nearby

                        SearchModel _ search ->
                            SearchModel arguments search
            in
                ( nextModel, Cmd.none )

        Process (Nearby arguments model msg) ->
            let
                result =
                    Update.Nearby.update msg model

                nextModel =
                    NearbyModel arguments (Tuple.first result)

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map (Nearby arguments (Tuple.first result))
                        |> Platform.Cmd.map Process
            in
                ( nextModel, nextCmd )

        Process (Search arguments model msg) ->
            let
                result =
                    Update.Search.update msg model

                nextModel =
                    SearchModel arguments (Tuple.first result)

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map (Search arguments (Tuple.first result))
                        |> Platform.Cmd.map Process
            in
                ( nextModel, nextCmd )
