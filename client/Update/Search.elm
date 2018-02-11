module Update.Search exposing (update)

import Task
import Result exposing (Result)
import Maybe
import Http
import Geolocation
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
        GetLocation agencyIds routeId ->
            ( Nil routeId, Task.attempt (useLocation agencyIds routeId) Geolocation.now )

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

        RequestRoute agencyIds routeId location ->
            let
                agencyId =
                    agencyIds
                        |> List.head
                        |> Maybe.withDefault "ttc"

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
                nearestStops : List Stop
                nearestStops =
                    schedule.routes
                        |> Model.Route.sortByDirections schedule.location.latitude schedule.location.longitude

                cmd : Cmd Msg
                cmd =
                    nearestStops
                        |> List.map (\stop -> requestPredictions stop.parent.parent.agencyId stop.parent.parent.id stop.id schedule.location.latitude schedule.location.longitude)
                        |> List.map Http.toTask
                        |> Task.sequence
                        |> Task.attempt ReceivePredictions
            in
                ( model, cmd )

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


useLocation : List String -> String -> Result Geolocation.Error Geolocation.Location -> Msg
useLocation agencyIds routeId result =
    case result of
        Ok location ->
            RequestRoute agencyIds routeId (Model.Common.Location location.latitude location.longitude)

        Err err ->
            UnavailableLocation routeId err
