module View exposing (view)

import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Model exposing (..)
import Model.Schedule exposing (Schedule)
import View.Schedule
import View.Error
import View.Alert.GetSchedule
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid exposing (container)
import Bootstrap.Alert as Alert


view : Model -> Html Msg
view model =
    case model of
        NoLocation ->
            container
                [ onClick (GetLocation 42) ]
                [ CDN.stylesheet
                , View.Alert.GetSchedule.view
                ]

        FoundLocation _ _ ->
            container
                [ onClick (GetLocation 42) ]
                [ CDN.stylesheet
                , View.Alert.GetSchedule.view
                ]

        FoundSchedule response ->
            container
                [ onClick (GetLocation 42) ]
                (CDN.stylesheet :: scheduleView response.schedule)

        Error error ->
            container
                [ onClick (GetLocation 42) ]
                [ CDN.stylesheet
                , View.Error.view error
                ]


scheduleView : Schedule -> List (Html Msg)
scheduleView schedule =
    View.Schedule.views schedule
