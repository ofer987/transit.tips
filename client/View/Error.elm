module View.Error exposing (view)

import Html exposing (Html, div, text)
import Model exposing (..)


view : Maybe String -> Html Msg
view error =
    case error of
        Just value ->
            div
                []
                [ text value ]

        Nothing ->
            div [] []
