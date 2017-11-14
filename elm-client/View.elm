module View exposing (view)

import Html exposing (Html, div)
import Html.Events exposing (onClick)
import Model exposing (..)
import Model.Schedule exposing (Schedule)
import View.Schedule
import View.Error


view : Model -> Html Msg
view model =
    div
        [ onClick (GetLocation 42) ]
        [ scheduleView model.schedule
        , View.Error.view model.error
        ]


scheduleView : Maybe Schedule -> Html Msg
scheduleView schedule =
    case schedule of
        Just value ->
            View.Schedule.view value

        Nothing ->
            emptyView


emptyView : Html Msg
emptyView =
    div [] []


errorView : Maybe String -> Html Msg
errorView error =
    View.Error.view error
