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

        NearbyModel model_ ->
            View.Nearby.view model_

        SearchModel model_ ->
            View.Search.view model_
