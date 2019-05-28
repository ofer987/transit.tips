module Update exposing (update)

import Model exposing (..)
import Model.Common exposing (Location)
import Model.Nearby
import Model.Search
import Model.Schedule
import Workflow.Nearby
import Workflow.Search
import Task
import Tuple
import Platform.Cmd


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        InitialNearby ->
            let
                inputs =
                    model.inputs

                initalCmd =
                    -- Task x Nearby.Msg
                    -- perform (Nearby.Msg -> Workflow)
                    -- map (Workflow -> Msg)
                    Model.Nearby.RequestSchedule inputs.location
                        |> Task.succeed
                        |> Task.perform Nearby
                        |> Platform.Cmd.map Process

                nextModel =
                    { model | inputs = inputs, results = DisplayNearby Model.Nearby.Nil }
            in
                ( nextModel, initalCmd )

        -- Do nothing
        InitialSearch _ "" ->
            ( model, Cmd.none )

        InitialSearch [] _ ->
            ( model, Cmd.none )

        InitialSearch agencyIds routeId ->
            let
                nextCmd =
                    Model.Search.RequestRoute agencyIds routeId inputs.location
                        |> Task.succeed
                        |> Task.perform Search
                        |> Platform.Cmd.map Process

                inputs =
                    model.inputs

                nextModel =
                    { model | inputs = inputs, results = DisplaySearch Model.Search.Nil }
            in
                ( nextModel, nextCmd )

        Update inputs ->
            let
                nextModel =
                    { model | inputs = inputs }
            in
                ( nextModel, Cmd.none )

        Process (Nearby msg) ->
            let
                nearbyModel =
                    case model.results of
                        Nil ->
                            Model.Nearby.Nil

                        DisplayNearby subModel ->
                            subModel

                        DisplaySearch _ ->
                            Model.Nearby.Nil

                result =
                    Workflow.Nearby.update msg nearbyModel

                nearby =
                    Tuple.first result

                nextModel =
                    { model | results = DisplayNearby nearby }

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map Nearby
                        |> Platform.Cmd.map Process

                -- case nearby of
                --     Model.Nearby.Nil ->
                --         arguments
                --
                --     Model.Nearby.HasLocation location ->
                --         arguments
                --
                --     Model.Nearby.ReceivedDate schedule _ ->
                --         { arguments | agencyIds = Model.Schedule.agencyIds schedule }
                --
                --     Model.Nearby.Error _ ->
                --         arguments
            in
                ( nextModel, nextCmd )

        Process (Search msg) ->
            let
                searchModel =
                    case model.results of
                        Nil ->
                            Model.Search.Nil

                        DisplayNearby _ ->
                            Model.Search.Nil

                        DisplaySearch subModel ->
                            subModel

                result =
                    Workflow.Search.update msg searchModel

                search =
                    Tuple.first result

                nextModel =
                    { model | results = DisplaySearch search }

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map Search
                        |> Platform.Cmd.map Process
            in
                ( nextModel, nextCmd )
