module View.Search exposing (view, searchFormView, nearbyFormView)

import Model exposing (..)
import Model.Common exposing (Location)
import Model.Search
import View.Alert.Error
import View.Loading
import View.Schedule
import View.Alert.GetSearchResults
import View.Alert.ReceivedSearchResults
import Html.Styled exposing (Html, toUnstyled, fromUnstyled, styled, div, text, input, button, form)
import Html.Styled.Attributes exposing (type_, value)
import Html.Styled.Events exposing (onInput, onClick, onSubmit)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid exposing (container)


view : Arguments -> Model.Search.Model -> Html Controller
view arguments model =
    case model of
        Model.Search.Nil ->
            fromUnstyled <|
                container
                    []
                    [ CDN.stylesheet
                    , View.Alert.Error.view "Could not find any route"
                    , toUnstyled View.Loading.view
                    ]

        Model.Search.InProgress ->
            Html.Styled.fromUnstyled <|
                container
                    []
                    [ CDN.stylesheet
                    , (View.Alert.GetSearchResults.view arguments.routeId)
                    , toUnstyled View.Loading.view
                    ]

        Model.Search.ReceivedPredictions schedule ->
            Html.Styled.fromUnstyled <|
                container
                    []
                    [ CDN.stylesheet
                    , View.Alert.ReceivedSearchResults.view
                    , toUnstyled (searchFormView arguments)
                    , toUnstyled nearbyFormView
                    , toUnstyled (View.Schedule.view schedule.routes)
                    ]

        Model.Search.Error error ->
            div
                []
                [ fromUnstyled CDN.stylesheet
                , fromUnstyled (View.Alert.Error.view error)
                , searchFormView arguments
                , nearbyFormView
                , fromUnstyled (View.Alert.Error.view error)
                ]


searchFormView : Arguments -> Html Controller
searchFormView arguments =
    form
        [ onSubmit (SearchController arguments.agencyIds arguments.routeId) ]
        [ text "Enter route"
        , input
            [ type_ "text"
            , value arguments.routeId
            , onInput (\value -> UpdateArguments (Arguments arguments.agencyIds value (Location 0.0 0.0)))
            ]
            []
        , button
            [ type_ "submit" ]
            [ text "Search" ]
        ]


nearbyFormView : Html Controller
nearbyFormView =
    form
        [ onSubmit NearbyController ]
        [ button
            [ type_ "submit" ]
            [ text "Search nearby" ]
        ]
