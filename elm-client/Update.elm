module Update exposing (update)

import Task
import Geolocation exposing (Error(..), Location)
import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetLocation _ ->
            ( model, Task.attempt useLocation Geolocation.now )

        SetLocation location ->
            ( { model | location = Just location }, Cmd.none )

        UnavailableLocation error ->
            ( { model | location = Nothing }, Cmd.none )

        None ->
            ( model, Cmd.none )


useLocation : Result Error Location -> Msg
useLocation result =
    case result of
        Ok location ->
            SetLocation location

        Err err ->
            UnavailableLocation err



-- toLocationErrorString : Error -> String
-- toLocationErrorString err =
--     case err of
--         PermissionDenied string ->
--             string
--
--         LocationUnavailable string ->
--             string
--
--         Timeout string ->
--             string
--
