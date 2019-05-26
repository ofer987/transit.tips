module Update.Search exposing (update)

import Task
import Utility.Task
import Result exposing (Result)
import Maybe
import Http
import String exposing (fromInt, fromFloat)
import Platform.Cmd
import Constants exposing (..)
import Model.Common exposing (..)
import Model.Search exposing (..)
import Model.Route
import Json.Route
import Json.Predictions
import Json.Decode.Route
import Json.Decode.Predictions
import Json.Convert.Route
import Json.Convert.Predictions


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestRoute (firstAgencyId :: otherAgencyIds) routeId location ->
            let
                request : String -> Cmd Msg
                request agencyId =
                    requestRoute location.longitude location.latitude agencyId routeId

                cmd : Cmd Msg
                cmd =
                    (firstAgencyId :: otherAgencyIds)
                        |> List.map request
                        |> Platform.Cmd.batch
            in
                ( model, cmd )

        RequestRoute [] routeId location ->
            ( Error "no agency", Cmd.none )

        ReceiveRoute (Ok jsonList) ->
            let
                routes =
                    jsonList
                        |> List.map Json.Convert.Route.toSchedule
                        |> List.map .routes
                        |> List.concatMap Model.Route.toList

                nearestStops : List Stop
                nearestStops =
                    routes
                        |> List.map (\route -> Model.Route.sortByDirections route.parent.location.latitude route.parent.location.longitude route)
                        |> List.concat

                cmd : Cmd Msg
                cmd =
                    nearestStops
                        |> List.map (\stop -> requestPredictions stop.parent.parent.agencyId stop.parent.parent.id stop.id stop.parent.parent.parent.location.latitude stop.parent.parent.parent.location.longitude)
                        |> Platform.Cmd.batch
            in
                ( model, cmd )

        ReceiveRoute (Err error) ->
            let
                message =
                    case error of
                        Http.BadUrl value ->
                            value

                        Http.Timeout ->
                            "Timeout"

                        Http.NetworkError ->
                            "Network error"

                        Http.BadStatus status ->
                            fromInt status

                        Http.BadBody value ->
                            "Error: " ++ value
            in
                ( Error message, Cmd.none )

        ReceivePredictions (Ok json) ->
            let
                toRoutesList : Routes -> List Route
                toRoutesList routes =
                    case routes of
                        Routes list ->
                            list

                convertedRoutes =
                    json
                        |> List.map Json.Convert.Predictions.toSchedule
                        |> List.map .routes
                        |> List.concatMap toRoutesList

                location =
                    Location 0.0 0.0

                schedule =
                    Model.Common.Schedule location Nothing (Routes convertedRoutes)
            in
                ( ReceivedPredictions schedule, Cmd.none )

        ReceivePredictions (Err error) ->
            let
                message =
                    case error of
                        Http.BadUrl value ->
                            value

                        Http.Timeout ->
                            "Timeout"

                        Http.NetworkError ->
                            "Network error"

                        Http.BadStatus status ->
                            String.fromInt status

                        Http.BadBody value ->
                            "Error: " ++ value
            in
                ( Error message, Cmd.none )


requestRoute : Float -> Float -> String -> String -> Cmd Msg
requestRoute latitude longitude agencyId routeId =
    let
        baseUrl =
            restbusUrl

        url =
            baseUrl ++ "/agencies/" ++ agencyId ++ "/routes/" ++ routeId

        expect : Http.Expect Msg
        expect =
            Http.expectJson
                ReceiveRoute
                (Json.Decode.Route.schedule latitude longitude agencyId)
    in
        Http.get
            { url = url
            , expect = expect
            }


requestPredictions : String -> String -> String -> Float -> Float -> Cmd Msg
requestPredictions agencyId routeId stopId latitude longitude =
    let
        baseUrl =
            restbusUrl

        url =
            baseUrl ++ "/agencies/" ++ agencyId ++ "/routes/" ++ routeId ++ "/stops/" ++ stopId ++ "/predictions"

        expect =
            Http.expectJson
                ReceivePredictions
                (Json.Decode.Predictions.schedule latitude longitude)
    in
        Http.get
            { url = url
            , expect = expect
            }
