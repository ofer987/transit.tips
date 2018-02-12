module View exposing (view)

import String
import Html exposing (Html, div, text)
import Model exposing (..)
import View.Nearby
import View.Search


view : Model -> Html Controller
view model =
    case model of
        Nil ->
            div [] []

        NearbyModel arguments model_ ->
            div
                []
                [ viewArguments arguments
                , View.Nearby.view arguments model_
                ]

        SearchModel arguments model_ ->
            div
                []
                [ viewArguments arguments
                , View.Search.view arguments model_
                ]


viewArguments : Arguments -> Html Controller
viewArguments arguments =
    div
        []
        [ text ("routeId = " ++ arguments.routeId)
        , text ("agencyIds = " ++ (String.join ", " arguments.agencyIds))
        ]
