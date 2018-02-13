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
import Json.Decode
import Json.Decode.Route
import Json.Decode.Predictions
import Json.Convert.Route
import Json.Convert.Predictions


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetLocation agencyIds routeId ->
            ( InProgress, Task.attempt (useLocation agencyIds routeId) Geolocation.now )

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

        RequestRoute (firstAgencyId :: otherAgencyIds) routeId location ->
            let
                request : String -> Http.Request (Maybe Json.Route.Schedule)
                request agencyId =
                    requestRoute location.longitude location.latitude agencyId routeId

                cmd : Cmd Msg
                cmd =
                    (firstAgencyId :: otherAgencyIds)
                        |> List.map request
                        |> List.map Http.toTask
                        |> List.map (Task.onError (\_ -> Task.succeed Nothing))
                        |> Task.sequence
                        |> Task.attempt ReceiveRoute
            in
                ( model, cmd )

        RequestRoute [] routeId location ->
            ( Error "no agency", Cmd.none )

        ReceiveRoute (Ok jsonList) ->
            let
                routes =
                    jsonList
                        |> List.filterMap identity
                        |> List.map Json.Convert.Route.toSchedule
                        |> List.map .routes
                        |> List.concatMap Model.Route.toList

                nearestStops : List Stop
                nearestStops =
                    routes
                        |> List.map (\route -> Model.Route.sortByDirections route.parent.location.latitude route.parent.location.longitude route)
                        |> List.concat

                cmd : Cmd Msg
                cmd =
                    nearestStops
                        |> List.map (\stop -> requestPredictions stop.parent.parent.agencyId stop.parent.parent.id stop.id stop.parent.parent.parent.location.latitude stop.parent.parent.parent.location.longitude)
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


requestRoute : Float -> Float -> String -> String -> Http.Request (Maybe Json.Route.Schedule)
requestRoute latitude longitude agencyId routeId =
    let
        url =
            "http://restbus.info/api/agencies/" ++ agencyId ++ "/routes/" ++ routeId
    in
        Json.Decode.Route.schedule latitude longitude agencyId
            |> Json.Decode.maybe
            |> Http.get url


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
