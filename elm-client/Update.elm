module Update exposing (update)

import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetLocation ->
            ( model, Cmd.none )

        None ->
            ( model, Cmd.none )
