module Update exposing (update)

import Dict exposing (Dict)
import Http
import Task
import Platform.Cmd as Cmd
import String
import Json.Convertor
import Json.Decoder
import Json.Encode exposing (Value)
import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestSchedule location ->
            let
                request : Cmd Msg
                request =
                    requestSchedule location.latitude location.longitude
            in
                ( model, request )

        ReceivedSchedule (Ok json) ->
            let
                schedule =
                    json
                        |> Json.Convertor.toModel

                location =
                    schedule.location
            in
                ( HasSchedule schedule location, Cmd.none )

        ReceivedSchedule (Err error) ->
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
                            "error: " ++ value
            in
                ( Error message, Cmd.none )


requestSchedule : Float -> Float -> Cmd Msg
requestSchedule latitude longitude =
    let
        restbusUrl : String
        restbusUrl =
            "http://localhost:3000"

        baseUrl : String
        baseUrl =
            restbusUrl

        url : String
        url =
            baseUrl ++ "/ttc/train/schedules/show?latitude=" ++ (String.fromFloat latitude) ++ "&longitude=" ++ (String.fromFloat longitude)

        expect : Http.Expect Msg
        expect =
            Http.expectJson
                ReceivedSchedule
                (Json.Decoder.model latitude longitude)
    in
        Http.get
            { url = url
            , expect = expect
            }
