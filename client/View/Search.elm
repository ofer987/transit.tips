module View.Search exposing (view, searchFormView, nearbyFormView)

import Model exposing (..)
import Model.Search
import View.Alert.Error
import View.Schedule
import View.Alert.GetSearchResults
import View.Alert.ReceivedSearchResults
import Html exposing (Html, div, text, input, button, form)
import Html.Attributes exposing (type_, defaultValue)
import Html.Events exposing (onInput, onClick, onSubmit)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid exposing (container)


view : Arguments -> Model.Search.Model -> Html Controller
view arguments model =
    case model of
        Model.Search.Nil ->
            container
                []
                [ CDN.stylesheet
                , View.Alert.GetSearchResults.view arguments.routeId
                , searchFormView arguments
                , nearbyFormView
                ]

        Model.Search.ReceivedPredictions schedule ->
            container
                []
                [ CDN.stylesheet
                , View.Alert.ReceivedSearchResults.view
                , searchFormView arguments
                , nearbyFormView
                , View.Schedule.view schedule.routes
                ]

        Model.Search.Error error ->
            div
                []
                [ CDN.stylesheet
                , View.Alert.Error.view error
                , searchFormView arguments
                , nearbyFormView
                , View.Alert.Error.view error
                ]


searchFormView : Arguments -> Html Controller
searchFormView arguments =
    form
        [ onSubmit (SearchController arguments.routeId) ]
        [ text "Search route"
        , input
            [ type_ "text"
            , defaultValue arguments.routeId
            , onInput (\value -> UpdateArguments (Arguments [] value))
            ]
            []
        , button
            [ type_ "submit" ]
            [ text "Click to select" ]
        ]


nearbyFormView : Html Controller
nearbyFormView =
    form
        [ onSubmit NearbyController ]
        [ button
            [ type_ "submit" ]
            [ text "Search nearby" ]
        ]
