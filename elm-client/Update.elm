module Update exposing (update)

import Task
import Geolocation exposing (Location)
import Http
import Model exposing (..)
import Model.Schedule exposing (Schedule)
import RestBus.Decoder


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetLocation _ ->
            ( model, Task.attempt useLocation Geolocation.now )

        SetLocation location ->
            let
                newModel =
                    { model | location = Just location }

                cmd =
                    Task.succeed location
                        |> Task.perform RequestSchedule
            in
                ( newModel, cmd )

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
                ( { model | location = Nothing, schedule = Nothing, error = Just message }, Cmd.none )

        RequestSchedule location ->
            let
                request =
                    requestSchedule location.latitude location.longitude

                cmd =
                    Http.send ReceiveSchedule request
            in
                ( model, cmd )

        ReceiveSchedule (Ok schedule) ->
            ( { model | schedule = Just schedule }, Cmd.none )

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
                ( { model | schedule = Nothing,  error = Just message }, Cmd.none )

        None ->
            ( model, Cmd.none )


useLocation : Result Geolocation.Error Location -> Msg
useLocation result =
    case result of
        Ok location ->
            SetLocation location

        Err err ->
            UnavailableLocation err



-- toLocationErrorString : Error -> String
-- toLocationErrorString err =
--     case err of
--         PermissionDenied string ->
--             string
--
--         LocationUnavailable string ->
--             string
--
--         Timeout string ->
--             string
--


requestSchedule : Float -> Float -> Http.Request Schedule
requestSchedule latitude longitude =
    let
        url =
            -- "https://restbus.transit.tips/nearby/index"
            "http://localhost:3000"

        fullUrl =
            url ++ "?latitude=" ++ (toString latitude) ++ "&longitude=" ++ (toString longitude)
    in
        Http.get fullUrl RestBus.Decoder.schedule
