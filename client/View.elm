module View exposing (view)

import Html exposing (Html, div)
import Html.Events exposing (onClick)
import Model exposing (..)
import Model.Schedule exposing (Schedule)
import View.Schedule
import View.Error

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid exposing (container)


view : Model -> Html Msg
view model =
    container
        [ onClick (GetLocation 42) ]
        ( CDN.stylesheet :: View.Error.view model.error :: scheduleView model.schedule)


scheduleView : Maybe Schedule -> List (Html Msg)
scheduleView schedule =
    case schedule of
        Just value ->
            View.Schedule.views value

        Nothing ->
            []
