module Workflow.Nearby exposing (update)

import Json.Convert.Predictions
import Task
import Time
import Http
import String exposing (fromInt, fromFloat)
import Constants exposing (..)
import Model.Nearby exposing (..)
import Model.Common exposing (..)
import Json.Predictions
import Json.Decode.Predictions


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestSchedule location ->
            let
                cmd =
                    requestNearby location.latitude location.longitude

                -- cmd =
                --     Http.send ReceiveSchedule request
            in
                ( model, cmd )

        ReceiveSchedule (Ok json) ->
            let
                cmd =
                    Json.Convert.Predictions.toSchedule json
                        |> Task.succeed
                        |> Task.perform RequestTime
            in
                ( model, cmd )

        ReceiveSchedule (Err error) ->
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

        RequestTime schedule ->
            ( model, Task.perform (ReceiveTime schedule) Time.now )

        ReceiveTime schedule date ->
            ( ReceivedDate schedule date, Cmd.none )


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
