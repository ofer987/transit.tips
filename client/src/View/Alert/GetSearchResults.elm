module View.Alert.GetSearchResults exposing (view)

import Html exposing (Html, div, text)
import Model exposing (..)
import Bootstrap.Alert as Alert


view : String -> Html Controller
view routeId =
    Alert.info [ text ("Getting Schedule for route " ++ routeId) ]
