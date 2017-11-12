module View exposing (view)

import Html exposing (Html, div)
import Model exposing (..)
import View.Schedule


view : Model -> Html Msg
view model =
    case model.schedule of
        Just schedule ->
            View.Schedule.view schedule

        Nothing ->
            emptyView

emptyView : Html Msg
emptyView =
    div [] []
