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
                arguments =
                    case model of
                        Nil ->
                            emptyInput

                        NearbyModel args _ ->
                            args

                        SearchModel args _ ->
                            args

                initalCmd =
                    -- Task x Nearby.Msg
                    -- perform (Nearby.Msg -> Workflow)
                    -- map (Workflow -> Msg)
                    Model.Nearby.RequestSchedule arguments.location
                        |> Task.succeed
                        |> Task.perform Nearby
                        |> Platform.Cmd.map Process

                nextModel =
                    NearbyModel arguments Model.Nearby.Nil
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
                    Model.Search.RequestRoute agencyIds routeId arguments.location
                        |> Task.succeed
                        |> Task.perform Search
                        |> Platform.Cmd.map Process

                arguments =
                    case model of
                        Nil ->
                            emptyInput

                        NearbyModel arguments_ _ ->
                            arguments_

                        SearchModel arguments_ _ ->
                            arguments_

                nextModel =
                    SearchModel arguments Model.Search.Nil
            in
                ( nextModel, nextCmd )

        Update arguments ->
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

        Process (Nearby msg) ->
            let
                nearbyModel =
                    case model of
                        Nil ->
                            Model.Nearby.Nil

                        NearbyModel _ subModel ->
                            subModel

                        SearchModel _ subModel ->
                            Model.Nearby.Nil

                result =
                    Update.Nearby.update msg nearbyModel

                nearby =
                    Tuple.first result

                nextModel =
                    NearbyModel nextArguments nearby

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map Nearby
                        |> Platform.Cmd.map Process

                nextArguments =
                    case model of
                        Nil ->
                            emptyInput

                        NearbyModel input _ ->
                            input

                        SearchModel input _ ->
                            input

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
                    case model of
                        Nil ->
                            Model.Search.Nil

                        NearbyModel _ subModel ->
                            Model.Search.Nil

                        SearchModel _ subModel ->
                            subModel

                result =
                    Update.Search.update msg searchModel

                nextArguments =
                    case model of
                        Nil ->
                            emptyInput

                        NearbyModel input _ ->
                            input

                        SearchModel input _ ->
                            input

                nextModel =
                    SearchModel nextArguments (Tuple.first result)

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map Search
                        |> Platform.Cmd.map Process
            in
                ( nextModel, nextCmd )
