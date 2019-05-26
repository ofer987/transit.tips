module View.Alert.GetSearchResults exposing (view)

import Html exposing (Html, div, text)
import Model exposing (..)
import Bootstrap.Alert as Alert


view : String -> Html Msg
view routeId =
    Alert.simpleInfo
        []
        [ text ("Getting Schedule for route " ++ routeId) ]
