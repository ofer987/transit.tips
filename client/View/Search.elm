module View.Search exposing (view, searchFormView, nearbyFormView)

import Model exposing (..)
import Model.Search
import Model.Search.Arguments exposing (Arguments)
import View.Alert.Error
import View.Schedule
import View.Loading
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
        Model.Search.Nil "" ->
            container
                []
                [ CDN.stylesheet
                , searchFormView arguments
                ]

        Model.Search.Nil routeId ->
            container
                []
                [ CDN.stylesheet
                , View.Alert.GetSearchResults.view routeId
                , searchFormView arguments
                , View.Loading.view
                ]

        -- Note: Currently not used
        Model.Search.ReceivedRoute routeId schedule ->
            container
                []
                [ CDN.stylesheet
                , View.Alert.GetSearchResults.view routeId
                , searchFormView arguments
                , nearbyFormView
                , View.Loading.view
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
searchFormView model =
    form
        [ onSubmit (SearchController model.routeId) ]
        [ text "please search!"
        , input
            [ type_ "text"
            , defaultValue model.routeId
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
            [ text "Click to select" ]
        ]
