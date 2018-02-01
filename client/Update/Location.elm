module Update.Location exposing (update)

import Task
import Geolocation exposing (Location)
import Model.Location exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetLocation ->
            ( Nil, Task.attempt useLocation Geolocation.now )

        SetLocation location ->
            ( ReceivedLocation location.latitude location.longitude
            , Cmd.none
            )

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

        None ->
            ( model, Cmd.none )


useLocation : Result Geolocation.Error Location -> Msg
useLocation result =
    case result of
        Ok location ->
            SetLocation location

        Err err ->
            UnavailableLocation err
