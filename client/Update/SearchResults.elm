-- Rename to Update.Search


module Update.SearchResults exposing (update)

import Tuple
import Task
import Geolocation exposing (Location)
import Http
import Model.SearchResults exposing (..)
import Model.Stop exposing (Stop, nilStop)
import Model.Route exposing (MyRoute, Route)
import Decoder.MyRoute
import Decoder.SearchResults


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetLocation routeId ->
            let
                cmd =
                    Geolocation.now
                        |> Task.map (\location -> ( location, routeId ))
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
                    requestRoute location.longitude location.latitude agencyId routeId

                cmd =
                    Http.send ReceiveRoute request
            in
                ( model, cmd )

        ReceiveRoute (Ok myRoute) ->
            let
                nearestStop =
                    findNearestStop myRoute.myLatitude myRoute.myLongitude myRoute.stops

                request =
                    requestArrivals myRoute.agencyId myRoute.id nearestStop.id
                        |> Http.send ReceiveArrivals
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
            ( ReceivedArrivals route, Cmd.none )

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


requestRoute : Float -> Float -> String -> String -> Http.Request MyRoute
requestRoute latitude longitude agencyId routeId =
    let
        url =
            "http://restbus.info/api/agencies/" ++ agencyId ++ "/routes/" ++ routeId
    in
        Http.get url (Decoder.MyRoute.myRoute agencyId latitude longitude)


requestArrivals : String -> String -> String -> Http.Request Route
requestArrivals agencyId routeId stopId =
    let
        url =
            "http://restbus.info/api/agencies/" ++ agencyId ++ "/routes/" ++ routeId ++ "/stops/" ++ stopId ++ "/predictions"
    in
        Http.get url Decoder.SearchResults.searchResults



-- Change to Result Error Stop


findNearestStop : Float -> Float -> List Stop -> Stop
findNearestStop latitude longitude stops =
    stops
        |> List.sortBy (\stop -> sqrt (((stop.latitude - latitude) ^ 2) + ((stop.longitude - longitude) ^ 2)))
        |> List.head
        |> Maybe.withDefault nilStop
