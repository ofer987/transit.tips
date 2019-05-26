module View.Nearby exposing (view)

import Html.Styled exposing (Html, fromUnstyled, toUnstyled, styled, div, text)
import Html exposing (div)
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
            fromUnstyled <|
                container
                    [ (onClick NearbyController) ]
                    [ CDN.stylesheet
                    , View.Alert.GetSchedule.view
                    , toUnstyled View.Loading.view
                    ]

        -- TODO: fix this
        Model.Nearby.HasLocation _ ->
            fromUnstyled <|
                container
                    [ onClick NearbyController ]
                    [ CDN.stylesheet
                    , View.Alert.GetSchedule.view
                    , toUnstyled View.Loading.view
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
                fromUnstyled <|
                    container
                        []
                        [ CDN.stylesheet
                        , alert
                        , toUnstyled (View.Search.searchFormView arguments)
                        , div
                            [ onClick NearbyController ]
                            [ toUnstyled <| View.Schedule.view schedule.routes ]
                        ]

        Model.Nearby.Error error ->
            fromUnstyled <|
                container
                    [ onClick NearbyController ]
                    [ CDN.stylesheet
                    , View.Alert.Error.view error
                    ]
