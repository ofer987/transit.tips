module View.Alert.Error exposing (view)

import Html exposing (Html, div, text)
import Model exposing (..)
import Bootstrap.Alert as Alert


view : String -> Html Msg
view error =
    Alert.danger
        [ div
            []
            [ text error ]
        ]
