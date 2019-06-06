module Workflow.Nearby exposing (update)

import Task
import Time
import Http
import String exposing (fromInt, fromFloat)
import Constants exposing (..)
import Model.Nearby exposing (..)
import Model.Common exposing (..)
import Json.Predictions
import Json.Decode.Predictions
import Json.Decode.Trains
import Json.Convert.Predictions
import Json.Convert.Trains


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestSchedule location ->
            let
                cmd =
                    requestNearby location.latitude location.longitude
            in
                ( model, cmd )

        ReceiveSchedule (Ok json) ->
            let
                schedule =
                    json
                        |> Json.Convert.Predictions.toSchedule

                location =
                    schedule.location

                cmd =
                    schedule
                        |> Task.succeed
                        |> Task.perform (RequestTrains location)
            in
                ( model, cmd )

        ReceiveSchedule (Err error) ->
            receivedError error

        RequestTrains location currentSchedule ->
            let
                cmd =
                    requestTrains location.latitude location.longitude currentSchedule
            in
                ( model, cmd )

        ReceivedTrains (Ok json) ->
            let
                schedule =
                    json
                        |> Json.Convert.Trains.toModel
            in
                ( model, Cmd.none )

        ReceivedTrains (Err err) ->
            receivedError err

        RequestTime schedule ->
            ( model, Task.perform (ReceiveTime schedule) Time.now )

        ReceiveTime schedule date ->
            ( ReceivedDate schedule date, Cmd.none )


requestTrains : Float -> Float -> Schedule -> Cmd Msg
requestTrains latitude longitude schedule =
    let
        baseUrl : String
        baseUrl =
            restbusUrl

        url : String
        url =
            baseUrl ++ "/ttc/train/schedules/show?latitude=" ++ (String.fromFloat latitude) ++ "&longitude=" ++ (String.fromFloat longitude)

        expect : Http.Expect Msg
        expect =
            Http.expectJson
                ReceivedTrains
                (Json.Decode.Trains.model latitude longitude schedule)
    in
        Http.get
            { url = url
            , expect = expect
            }


requestNearby : Float -> Float -> Cmd Msg
requestNearby latitude longitude =
    let
        baseUrl =
            restbusUrl

        url =
            baseUrl ++ "/?latitude=" ++ (fromFloat latitude) ++ "&longitude=" ++ (fromFloat longitude)

        expect =
            Http.expectJson
                ReceiveSchedule
                (Json.Decode.Predictions.nearby)
    in
        Http.get
            { url = url
            , expect = expect
            }


receivedError : Http.Error -> ( Model, Cmd Msg )
receivedError error =
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
