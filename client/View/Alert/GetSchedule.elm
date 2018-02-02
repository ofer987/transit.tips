module View.Alert.GetSchedule exposing (view)

import Html exposing (Html, div, text)
import Model exposing (..)
import Bootstrap.Alert as Alert


view : Html Controller
view =
    Alert.info [ text "Getting Schedule" ]
