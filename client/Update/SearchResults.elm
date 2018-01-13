-- Rename to Update.Search
module Update.SearchResults exposing (update)

import Tuple
import Task
import Geolocation exposing (Location)
import Http
import Model.SearchResults exposing (..)
import Model.Stop exposing (Stop, nilStop)
import Model.Route exposing (Route)
import RestBus.Decoder as Decoder


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetLocation routeId ->
            let
                cmd =
                    Geolocation.now
                        |> Task.map (\location -> (location, routeId))
                        |> Task.attempt useLocation

            in
                ( NoLocation, cmd )

        SetLocation location routeId ->
            let
                newModel =
                    ReceivedLocation location.latitude location.longitude

                -- Is there a better way?
                cmd =
                    Task.succeed routeId
                        |> Task.perform (RequestRoute location)
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
                -- Where do I get the agency from?
                agencyId =
                    "ttc"

                request =
                    requestRoute agencyId routeId

                cmd =
                    Http.send ReceiveRoute request
            in
                ( model, cmd )

        ReceiveRoute (Ok route) ->
            let
                nearestStop =
                    findNearestStop route.stops

                request =
                    requestArrivals route.id nearestStop.id
                        |> Task.succeed
                        |> Task.perform ReceiveArrivals
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

        ReceiveArrivals (Ok route) ->
            ( ReceivedRoute route, Cmd.none )

        ReceiveArrivals (Err error) ->
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


useLocation : Result Geolocation.Error ( Location, String ) -> Msg
useLocation result =
    case result of
        Ok value ->
            SetLocation (Tuple.first value) (Tuple.second value)

        Err err ->
            UnavailableLocation err


requestRoute : String -> String -> Http.Request Route
requestRoute agencyId routeId =
    let
        url =
            "http://restbus.info/api/agencies/" ++ agencyId ++ "/routes/" ++ routeId
    in
        Http.get url Decoder.model


requestArrivals : String -> String -> String -> Http.Request Route
requestArrivals agencyId routeId stopId =
    let
        url =
            "http://restbus.info/api/agencies/" ++ agencyId ++ "/routes/" ++ routeId ++ "/stops/ " ++ stopId ++ "/predictions"
    in
        Http.get url Decoder.model

-- Change to Result Error Stop
findNearestStop : Float -> Float -> List Stop -> Stop
findNearestStop latitude longitude stops =
    stops
        |> List.sortBy (\stop -> sqrt (((stop.latitude - latitude) ^ 2) + ((stop.longitude - longitude) ^ 2)))
        |> List.head
        |> Maybe.withDefault nilStop
