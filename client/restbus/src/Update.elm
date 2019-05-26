module Update exposing (update)

import Model exposing (..)
import Model.Common exposing (Location)
import Model.Nearby
import Model.Search
import Model.Schedule
import Update.Nearby
import Update.Search
import Task
import Tuple
import Platform.Cmd


update : Msg -> Model -> ( Model, Cmd Msg )
update controller model =
    case controller of
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
                    Model.Nearby.RequestSchedule arguments.location
                        |> Task.succeed
                        |> Task.perform (Nearby arguments (Model.Nearby.HasLocation arguments.location))
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
                        |> Task.perform (Search arguments Model.Search.Nil)
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
                result =
                    Update.Nearby.update msg model

                nearby =
                    Tuple.first result

                nextModel =
                    NearbyModel nextArguments nearby

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map (Nearby nextArguments (Tuple.first result))
                        |> Platform.Cmd.map Process

                nextArguments =
                    case nearby of
                        Model.Nearby.Nil ->
                            arguments

                        Model.Nearby.HasLocation location ->
                            arguments

                        Model.Nearby.ReceivedDate schedule _ ->
                            { arguments | agencyIds = Model.Schedule.agencyIds schedule }

                        Model.Nearby.Error _ ->
                            arguments
            in
                ( nextModel, nextCmd )

        Process (Search arguments mdl msg) ->
            let
                result =
                    Update.Search.update msg mdl

                nextModel =
                    SearchModel arguments (Tuple.first result)

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map (Search arguments (Tuple.first result))
                        |> Platform.Cmd.map Process
            in
                ( nextModel, nextCmd )
