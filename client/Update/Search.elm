module Update.Search exposing (update)

import Task
import Result exposing (Result)
import Http
import Geolocation
import Model.Common exposing (..)
import Model.Search exposing (..)
import Json.Route
import Json.Predictions
import Json.Decode.Route
import Json.Decode.Predictions
import Json.Convert.Route
import Json.Convert.Predictions


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetLocation routeId ->
            ( Nil, Task.attempt (useLocation routeId) Geolocation.now )

        UnavailableLocation routeId error ->
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

        RequestRoute routeId location ->
            let
                -- Where do I get the agency from?
                agencyId =
                    "ttc"

                request =
                    requestRoute location.longitude location.latitude agencyId routeId

                cmd =
                    Http.send ReceiveRoute request
            in
                ( model, cmd )

        ReceiveRoute (Ok json) ->
            let
                schedule =
                    Json.Convert.Route.toSchedule json

                -- assumes only one agency!
                -- TODO: make it per agency
                nearestStop : Maybe Stop
                nearestStop =
                    schedule.routes
                        |> Model.Common.sortByStop schedule.location.latitude schedule.location.longitude
                        |> List.head
            in
                case nearestStop of
                    Just stop ->
                        let
                            route =
                                direction.parent

                            direction =
                                stop.parent

                            request =
                                requestPredictions route.agencyId route.id stop.id schedule.location.latitude schedule.location.longitude

                            cmd =
                                Http.send ReceivePredictions request
                        in
                            ( model, cmd )

                    Nothing ->
                        ( Error "no stops found", Cmd.none )

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

        ReceivePredictions (Ok json) ->
            ( ReceivedPredictions (Json.Convert.Predictions.toSchedule json), Cmd.none )

        ReceivePredictions (Err error) ->
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
            ( Nil, Cmd.none )


requestRoute : Float -> Float -> String -> String -> Http.Request Json.Route.Schedule
requestRoute latitude longitude agencyId routeId =
    let
        url =
            "http://restbus.info/api/agencies/" ++ agencyId ++ "/routes/" ++ routeId
    in
        Http.get url (Json.Decode.Route.schedule latitude longitude agencyId)


requestPredictions : String -> String -> String -> Float -> Float -> Http.Request Json.Predictions.Schedule
requestPredictions agencyId routeId stopId latitude longitude =
    let
        url =
            "http://restbus.info/api/agencies/" ++ agencyId ++ "/routes/" ++ routeId ++ "/stops/" ++ stopId ++ "/predictions"
    in
        Http.get url (Json.Decode.Predictions.schedule latitude longitude)


useLocation : String -> Result Geolocation.Error Geolocation.Location -> Msg
useLocation routeId result =
    case result of
        Ok location ->
            RequestRoute routeId (Model.Common.Location location.latitude location.longitude)

        Err err ->
            UnavailableLocation routeId err
