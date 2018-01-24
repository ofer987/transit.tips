module Update.Search exposing (update)

import Tuple
import Task
import Result exposing (Result)
import Geolocation exposing (Location)
import Http
import Model.SearchResults exposing (..)
import Model.Route exposing (MyRoute, Route)
import Decoder.MyRoute
import Decoder.SearchResults


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

        ReceiveRoute (Ok myRoute) ->
            let
                nearestStop =
                    myRoute.stops
                        |> List.sortBy (\stop -> sqrt (((stop.latitude - myRoute.myLatitude) ^ 2) + ((stop.longitude - myRoute.myLongitude) ^ 2)))
                        |> List.head
            in
                case nearestStop of
                    Just value ->
                        ( model, Http.send ReceiveArrivals (requestPredictions myRoute.agencyId myRoute.id value.id) )

                    Nothing ->
                        ( Error "No stops found", Cmd.none )

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

        ReceiveArrivals (Ok (Just route)) ->
            ( ReceivedArrivals route, Cmd.none )

        ReceiveArrivals (Ok Nothing) ->
            ( Error "Route did not contain information", Cmd.none )

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
            ( None, Cmd.none )


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
        Http.get url (Decoder.MyRoute.myRoute agencyId latitude longitude)


requestPredictions : String -> String -> String -> Http.Request (Maybe Route)
requestPredictions agencyId routeId stopId =
    let
        url =
            "http://restbus.info/api/agencies/" ++ agencyId ++ "/routes/" ++ routeId ++ "/stops/" ++ stopId ++ "/predictions"
    in
        Http.get url Decoder.SearchResults.searchResults
