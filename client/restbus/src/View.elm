module View exposing (view)

import String
import Html.Styled exposing (Html, div, text)
import Model exposing (..)
import View.Nearby
import View.Search


view : Model -> Html Msg
view model =
    case model.results of
        Nil ->
            div [] []

        DisplayNearby subModel ->
            div
                []
                [ View.Nearby.view model.inputs subModel ]

        DisplaySearch subModel ->
            div
                []
                [ View.Search.view model.inputs subModel ]


viewArguments : Input -> Html Msg
viewArguments inputs =
    div
        []
        [ text ("routeId = " ++ inputs.routeId)
        , text ("agencyIds = " ++ (String.join ", " inputs.agencyIds))
        ]
