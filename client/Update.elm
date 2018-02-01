module Update exposing (update)

import Model exposing (..)
import Update.Location as Location
import Update.Nearby as Nearby
import Update.Search as Search
import Tuple
import Platform.Cmd


update : ControllerMsg -> Model -> ( Model, Cmd ControllerMsg )
update controller model =
    case controller of
        Nearby ->
            let
                nextController =
                        Task.succeed Location.GetLocation
                            |> Task.perform (DoLocation NearbyController)

            in
                ( model, nextController )
        -- Search

        DoLocation controller msg ->
            let
                result =
                    Location.update msg model.location

                nextModel =
                    Tuple.first result

                nextMsg =
                    Tuple.second result
                        |> Platform.Cmd.map DoLocation

            in
                if end then
                    case controller of
                        NearbyController ->
                            ( model, DoNearby (RequestSchedule model.location))
                        SearchController routeId ->
                            ( model, DoSearch (RequestRoute model.location routeId))
                else
                    ( model, DoLocation nextMsg )
            result =
                Location.update GetLocation model.location
            case step of
                NotStarted ->
                    let
                        result =
                            Location.update GetLocation model.location

                        location =
                            Tuple.first result

                        nextMsg =
                            Tuple.second result

                        nextController =
                            DoLocation nextMsg

                        nextModel =
                            { model | location = location }

                    in
                        ( nextModel, controller )
            case controller of
                Location ->
                    let
                        result =
                            Update.Location.update (Location.GetLocation 42) model.location

                        nextModel =
                            { model | location = Tuple.first result }

                        nextCmd =
                            Tuple.second result
                                |> Platform.Cmd.map LocationController
                    in
                        ( nextModel, nextCmd )

        LocationController msg ->
            let
                result =
                    Update.Location.update msg model.location

                nextModel =
                    { model | location = Tuple.first result }

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map LocationController
            in
                ( nextModel, nextCmd )

        NearbyController msg ->
            let
                result =
                    Update.Nearby.update msg model.nearby

                nextModel =
                    { model | nearby = Tuple.first result }

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map NearbyController
            in
                ( nextModel, nextCmd )

        SearchController msg ->
            let
                result =
                    Update.Search.update msg model.search

                nextModel =
                    { model | search = Tuple.first result }

                nextCmd =
                    Tuple.second result
                        |> Platform.Cmd.map SearchController
            in
                ( nextModel, nextCmd )
