module Update.Search exposing (update)

import Tuple
import Task
import Result exposing (Result)
import Http
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
        RequestRoute location routeId ->
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

        ReceiveRoute (Ok schedule) ->
            let
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

                            stopSchedule =
                                Schedule
                                    schedule.location
                                    schedule.address
                                    [ { route | directions = [ { direction | stops = [ stop ] } ] } ]

                            newModel =
                                Json.Convert.Route.toSchedule stopSchedule

                            cmd =
                                requestPredictions route.agencyId route.id stop.id
                                    |> Http.send ReceivePredictions
                        in
                            ( newModel, cmd )

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

        ReceivePredictions (Ok (Just json)) ->
            ( ReceivedPredictions (Json.Convert.Predictions.toSchedule json), Cmd.none )

        ReceivePredictions (Ok Nothing) ->
            ( Error "route did not have stops", Cmd.none )

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


useLocation : Result Geolocation.Error ( Location, String ) -> Msg
useLocation result =
    case result of
        Ok value ->
            SetLocation (Tuple.first value) (Tuple.second value)

        Err err ->
            UnavailableLocation err


requestRoute : Float -> Float -> String -> String -> Http.Request Json.Route.Schedule
requestRoute latitude longitude agencyId routeId =
    let
        url =
            "http://restbus.info/api/agencies/" ++ agencyId ++ "/routes/" ++ routeId
    in
        Http.get url (Json.Decode.Route.schedule latitude longitude agencyId)


requestPredictions : String -> String -> String -> Http.Request (Maybe Route)
requestPredictions agencyId routeId stopId =
    let
        url =
            "http://restbus.info/api/agencies/" ++ agencyId ++ "/routes/" ++ routeId ++ "/stops/" ++ stopId ++ "/predictions"
    in
        Http.get url Decoder.Search.searchResults
