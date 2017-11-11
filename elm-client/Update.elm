module Update exposing (update)

import Task
import Geolocation exposing (Error, Location)
import Model exposing (..)


attemptLocation : Result Error Location -> Msg
attemptLocation result =
    case result of
        Ok location ->
            SetLocation location

        Err err ->
            NoLocation err


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetLocation _ ->
            ( model, Task.attempt attemptLocation Geolocation.now )

        SetLocation location ->
            -- ( { model | locationLatitude = location.latitude, locationLongitude = location.longitude }, Cmd.none )
            ( model, Cmd.none )

        NoLocation error ->
            ( model, Cmd.none )

        None ->
            ( model, Cmd.none )
