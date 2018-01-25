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
                cmd =
                    Json.Convert.Route.toSchedule schedule
                        |> Task.succeed
                        |> Task.perform FindNearestStop


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


        FindNearestStop (schedule) ->
            let
                -- assumes only one agency!
                -- TODO: make it per agency
                stops : List Stop
                stops =
                    schedule.routes
                        |> List.map .directions
                        |> List.concat
                        |> List.map .stops
                        |> List.concat

                nearestStop : Stop
                nearestStop =
                    stops
                        |> Model.Common.sortedStopsByPosition schedule.location.latitude schedule.location.longitude
                        |> List.head

                -- TODO: need the routeId

                model =
                    model

                -- TODO: figure out the error
                cmd =
                    nearestStop
                        |> Task.succeed
                        |> Task.perform RequestPredictions schedule
            in
                ( model, cmd )

                -- case nearestStop of
                --     Just value ->
                --         ( model, Http.send ReceiveArrivals (requestPredictions myRoute.agencyId myRoute.id value.id) )
                --
                --     Nothing ->
                --         ( Error "No stops found", Cmd.none )

        RequestPredictions schedule stop ->
            let
                model =
                    model

                cmd =
                    requestPredictions "ttc" routeId stop.id
                        |> Http.send

            in
                ( model, cmd)



        ReceivePredictions (Ok (Just route)) ->
            ( ReceivedArrivals route, Cmd.none )

        ReceivePredictions (Ok Nothing) ->
            ( Error "Route did not contain information", Cmd.none )

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


requestRoute : Float -> Float -> String -> String -> Http.Request MyRoute
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
