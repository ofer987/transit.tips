module View.Nearby exposing (view)

import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Model exposing (..)
import Model.Nearby
import View.Schedule
import View.Loading
import View.Search
import View.Alert.GetSchedule
import View.Alert.LocationAndTime
import View.Alert.Time
import View.Alert.Error
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid exposing (container)


view : Arguments -> Model.Nearby.Model -> Html Controller
view arguments model =
    case model of
        Model.Nearby.Nil ->
            container
                [ onClick NearbyController ]
                [ CDN.stylesheet
                , View.Alert.GetSchedule.view
                , View.Loading.view
                ]

        Model.Nearby.ReceivedSchedule _ ->
            container
                [ onClick NearbyController ]
                [ CDN.stylesheet
                , View.Alert.GetSchedule.view
                , View.Loading.view
                ]

        Model.Nearby.ReceivedDate schedule date ->
            let
                alert =
                    case schedule.address of
                        Just value ->
                            View.Alert.LocationAndTime.view schedule.location.latitude schedule.location.longitude value date

                        Nothing ->
                            View.Alert.Time.view schedule.location.latitude schedule.location.longitude date
            in
                container
                    []
                    [ CDN.stylesheet
                    , alert
                    , View.Search.searchFormView arguments
                    , div
                        [ onClick NearbyController ]
                        [ View.Schedule.view schedule.routes ]
                    ]

        Model.Nearby.Error error ->
            container
                [ onClick NearbyController ]
                [ CDN.stylesheet
                , View.Alert.Error.view error
                ]
