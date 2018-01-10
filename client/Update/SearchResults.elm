module Update.SearchResults exposing (update)

import Task
import Date
import Geolocation exposing (Location)
import Http
import Model.SearchResults exposing (..)
import Model.Nearby exposing (Nearby)
import Model.Schedule exposing (Schedule)
import RestBus.Decoder as Decoder


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetLocation _ ->
            ( NoLocation, Task.attempt useLocation Geolocation.now )

        SetLocation location ->
            let
                newModel =
                    ReceivedLocation location.latitude location.longitude

                cmd =
                    Task.succeed location
                        |> Task.perform RequestRoute
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
                ( Error message, Cmd.none )

        RequestRoute location routeId ->
            let
                request =
                    requestRoute location.latitude location.longitude routeId

                cmd =
                    Http.send ReceiveRoute request
            in
                ( model, cmd )

        ReceiveRoute (Ok route) ->
            let
                nearestStop =
                    findNearestStop route.stops
                request =
                    requestStops route.id nearestStop
                    -- Date.now
                    --     |> Task.perform (ReceiveTime response)
            in
                ( model, request )

        ReceiveRoute (Err error) ->
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

        RequestStops routeId stopId
            ( model, ReceiveStops )

        ReceiveStops (Ok route)
            ( route, Cmd.none )

        ReceiveStops (Err error) ->
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
        None ->
            ( model, Cmd.none )


useLocation : Result Geolocation.Error Location -> Msg
useLocation result =
    case result of
        Ok location ->
            SetLocation location

        Err err ->
            UnavailableLocation err


requestSchedule : Float -> Float -> Http.Request Nearby
requestSchedule latitude longitude =
    let
        url =
            "<%= restbus_url %>"

        fullUrl =
            url ++ "?latitude=" ++ (toString latitude) ++ "&longitude=" ++ (toString longitude)
    in
        Http.get fullUrl Decoder.model
