module View exposing (view)

import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Model exposing (..)
import Model.Schedule exposing (Schedule)
import View.Schedule
import View.Error

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid exposing (container)


view : Model -> Html Msg
view model =
    case model of
        NoLocation ->
            container
                [ onClick (GetLocation 42) ]
                [ CDN.stylesheet
                , getLocationView
                ]

        FoundLocation location ->
            container
                [ onClick (GetLocation 42) ]
                [ CDN.stylesheet
                , getLocationView
                ]

        FoundSchedule schedule ->
            container
                [ onClick (GetLocation 42) ]
                ( CDN.stylesheet :: scheduleView schedule)

        Error error ->
            container
                [ onClick (GetLocation 42) ]
                [ CDN.stylesheet
                , View.Error.view error
                ]


scheduleView : Schedule -> List (Html Msg)
scheduleView schedule =
    View.Schedule.views schedule

getLocationView : Html Msg
getLocationView =
    text "getting location"
