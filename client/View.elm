module View exposing (view)

import Html exposing (Html, div, text)
import Model exposing (..)
import View.Nearby
import View.Search


view : Model -> Html Controller
view model =
    case model of
        Nil ->
            div [] []

        NearbyModel model ->
            View.Nearby.view model

        SearchModel model ->
            View.Search.view model
