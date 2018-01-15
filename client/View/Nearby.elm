module View.Nearby exposing (view)

import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Model exposing (ControllerMsg(..))
import Model.Nearby exposing (Model(..), Msg(..))
import View.Schedule
import View.Loading
import View.Alert.GetSchedule
import View.Alert.LocationAndTime
import View.Alert.Time
import View.Alert.Error
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid exposing (container)


view : Model -> Html ControllerMsg
view model =
    case model of
        NoLocation ->
            container
                [ onClick (NearbyController (GetLocation 42)) ]
                [ CDN.stylesheet
                , View.Alert.GetSchedule.view
                , View.Loading.view
                ]

        ReceivedLocation _ _ ->
            container
                [ onClick (NearbyController (GetLocation 42)) ]
                [ CDN.stylesheet
                , View.Alert.GetSchedule.view
                , View.Loading.view
                ]

        ReceivedSchedule _ ->
            container
                [ onClick (NearbyController (GetLocation 42)) ]
                [ CDN.stylesheet
                , View.Alert.GetSchedule.view
                , View.Loading.view
                ]

        ReceivedDate nearby date ->
            let
                alert =
                    case nearby.address of
                        Just value ->
                            View.Alert.LocationAndTime.view nearby.latitude nearby.longitude value date

                        Nothing ->
                            View.Alert.Time.view nearby.latitude nearby.longitude date
            in
                container
                    [ onClick (NearbyController (GetLocation 42)) ]
                    (CDN.stylesheet :: alert :: View.Schedule.views nearby.schedule)

        Error error ->
            container
                [ onClick (NearbyController (GetLocation 42)) ]
                [ CDN.stylesheet
                , View.Alert.Error.view error
                ]
