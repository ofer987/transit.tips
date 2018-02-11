module Update exposing (update)

import Model exposing (..)
import Model.Nearby
import Model.Search
import Model.Schedule
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

                nextModel =
                    NearbyModel arguments Model.Nearby.Nil
            in
                ( nextModel, nextCmd )

        -- Do nothing
        SearchController _ "" ->
            ( model, Cmd.none )

        SearchController agencyIds routeId ->
            let
                nextCmd =
                    Task.succeed (Model.Search.GetLocation agencyIds routeId)
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

                        Model.Nearby.ReceivedSchedule schedule ->
                            { arguments | agencyIds = Model.Schedule.agencyIds schedule }

                        Model.Nearby.ReceivedDate _ _ ->
                            arguments

                        Model.Nearby.Error _ ->
                            arguments
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
