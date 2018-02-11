module View.Search exposing (view, searchView)

import Model exposing (..)
import Model.Search
import Model.Search.Arguments exposing (Arguments)
import View.Alert.Error
import View.Schedule
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
                [ onClick (SearchController arguments.routeId) ]
                [ CDN.stylesheet
                , searchView arguments
                ]

        Model.Search.Nil routeId ->
            container
                []
                [ CDN.stylesheet
                , searchView arguments
                , text ("searching route " ++ routeId)
                ]

        -- Note: Currently not used
        Model.Search.ReceivedRoute routeId schedule ->
            container
                []
                [ CDN.stylesheet
                , searchView arguments
                , text ("searching route " ++ routeId)
                ]

        Model.Search.ReceivedPredictions schedule ->
            container
                [ onClick (SearchController arguments.routeId) ]
                [ CDN.stylesheet
                , searchView arguments
                , text "received predictions"
                , View.Schedule.view schedule.routes
                ]

        Model.Search.Error error ->
            div
                []
                [ CDN.stylesheet
                , searchView arguments
                , View.Alert.Error.view error
                ]


searchView : Arguments -> Html Controller
searchView model =
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


noSearchView : Html Controller
noSearchView =
    div [] []
