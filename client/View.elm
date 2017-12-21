module View exposing (view)

import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Model exposing (..)
import View.Schedule
import View.Alert.GetSchedule
import View.Alert.Location
import View.Alert.Error
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid exposing (container)


view : Model -> Html Msg
view model =
    case model of
        NoLocation ->
            container
                [ onClick (GetLocation 42) ]
                [ CDN.stylesheet
                , View.Alert.GetSchedule.view
                ]

        ReceivedLocation _ _ ->
            container
                [ onClick (GetLocation 42) ]
                [ CDN.stylesheet
                , View.Alert.GetSchedule.view
                ]

        ReceivedSchedule _ ->
            container
                [ onClick (GetLocation 42) ]
                [ CDN.stylesheet
                , View.Alert.GetSchedule.view
                ]

        ReceivedDate nearby date ->
            container
                [ onClick (GetLocation 42) ]
                (CDN.stylesheet :: View.Alert.Location.view nearby.latitude nearby.longitude nearby.address date :: View.Schedule.views nearby.schedule)

        Error error ->
            container
                [ onClick (GetLocation 42) ]
                [ CDN.stylesheet
                , View.Alert.Error.view error
                ]
