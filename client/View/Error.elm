module View.Error exposing (view)

import Html exposing (Html, div, text)
import Model exposing (..)


view : String -> Html Msg
view error =
    div
        []
        [ text error ]
