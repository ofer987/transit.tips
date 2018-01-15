module View exposing (view)

import Html exposing (Html, div, text)
import Model exposing (..)
import View.Nearby
import View.Search


view : Model -> Html ControllerMsg
view model =
    div
        []
        [ View.Search.view model.search
        , View.Nearby.view model.nearby
        ]
