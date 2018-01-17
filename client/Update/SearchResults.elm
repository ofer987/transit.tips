-- Rename to Update.Search


module Update.SearchResults exposing (update)

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
                    myRoute.stops
                        |> List.sortBy (\stop -> sqrt (((stop.latitude - myRoute.myLatitude) ^ 2) + ((stop.longitude - myRoute.myLongitude) ^ 2)))
                        |> List.head
            in
                case nearestStop of
                    Just value ->
                        ( model, Http.send ReceiveArrivals (requestArrivals myRoute.agencyId myRoute.id value.id) )

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


requestArrivals : String -> String -> String -> Http.Request (Maybe Route)
requestArrivals agencyId routeId stopId =
    let
        url =
            "http://restbus.info/api/agencies/" ++ agencyId ++ "/routes/" ++ routeId ++ "/stops/" ++ stopId ++ "/predictions"
    in
        Http.get url Decoder.SearchResults.searchResults
