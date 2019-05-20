module Update.Nearby exposing (update)

import Json.Convert.Predictions
import Task
import Time
import Http
import Geolocation
import Constants exposing (..)
import Model.Nearby exposing (..)
import Model.Common exposing (..)
import Json.Predictions
import Json.Decode.Predictions


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetLocation ->
            ( Nil, Task.attempt useLocation Geolocation.now )

        UnavailableLocation error ->
            let
                message =
                    case error of
                        Geolocation.PermissionDenied value ->
                            value

                        Geolocation.LocationUnavailable value ->
                            value

                        Geolocation.Timeout value ->
                            value
            in
                ( Error message, Cmd.none )

        RequestSchedule location ->
            let
                request =
                    requestNearby location.latitude location.longitude

                cmd =
                    Http.send ReceiveSchedule request
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
                        Http.BadUrl message ->
                            message

                        Http.Timeout ->
                            "Timeout"

                        Http.NetworkError ->
                            "Network error"

                        Http.BadStatus response ->
                            toString response.status.code

                        Http.BadPayload message _ ->
                            message
            in
                ( Error message, Cmd.none )

        RequestTime schedule ->
            ( model, Task.perform (ReceiveTime schedule) Time.now )

        ReceiveTime schedule date ->
            ( ReceivedDate schedule date, Cmd.none )


requestNearby : Float -> Float -> Http.Request Json.Predictions.Schedule
requestNearby latitude longitude =
    let
        baseUrl =
            restbusUrl

        url =
            baseUrl ++ "/?latitude=" ++ (toString latitude) ++ "&longitude=" ++ (toString longitude)
    in
        Http.get url Json.Decode.Predictions.nearby


useLocation : Result Geolocation.Error Geolocation.Location -> Msg
useLocation result =
    case result of
        Ok location ->
            RequestSchedule (Model.Common.Location location.latitude location.longitude)

        Err err ->
            UnavailableLocation err
