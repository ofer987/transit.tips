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

        NearbyModel arguments model_ ->
            View.Nearby.view arguments model_

        SearchModel arguments model_ ->
            View.Search.view arguments model_
