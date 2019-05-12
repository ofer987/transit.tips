module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Update exposing (update)
import Model exposing (..)


main =
    Browser.element { init = 0, update = update, view = view }
