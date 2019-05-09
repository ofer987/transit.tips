module Update exposing (update)

import Http
import PortFunnel.Geolocation
import Model exposing (..)


update : Msg -> Model -> Model
update msg model =
    case msg of
        GetLocation ->
            ( InProgress, Task.attempt useLocation Geolocation.now )

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
                request : Cmd Msg
                request =
                    requestSchedule location.longitude location.latitude
            in
                ( model, cmd )

        ReceivedSchedule (Ok json) ->
            let
                schedule =
                    json
                        |> Json.Convert.toSchedule
            in
                ( Received schedule, Cmd.none )

        ReceivedSchedule (Err error) ->
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


requestSchedule : Float -> Float -> Cmd Msg
requestSchedule latitude longitude =
    let
        baseUrl : String
        baseUrl =
            restbusUrl

        url : String
        url =
            baseUrl ++ "/ttc/train/schedules/show?latitude=" ++ (toString latitude) ++ "&longitude=" + (toString longitude)

        expect : Http.Expect Msg
        expect =
            Http.expectJson
                ReceivedSchedule
                (Json.Decode.schedule latitude longitude)
    in
        Http.get
            { url = url
            , expect = expect
            }


useLocation : Result Geolocation.Error Geolocation.Location -> Msg
useLocation result =
    case result of
        Ok location ->
            RequestSchedule (Model.Location location.latitude location.longitude)

        Err err ->
            UnavailableLocation routeId err
