module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Update exposing (update)
import Model exposing (..)
import View exposing (view)


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : Location -> ( Model, Cmd Msg )
init location =
    ( HasLocation location, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
