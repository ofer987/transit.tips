module View.Route exposing (view)

import MyCss exposing (..)
import Html.CssHelpers
import Html exposing (Html, tbody, tr, td, span, text)
import Model exposing (..)
import Model.Route exposing (Route)
import Model.Arrival exposing (Arrival)
import View.Arrival exposing (view)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "TransitTips"


view : Route -> Html Msg
view route =
    tbody
        [ class [ MyCss.Route ] ]
        (titleRow route.title :: arrivalRows route.arrivals)


titleRow : String -> Html Msg
titleRow title =
    tr
        []
        [ span
            [ class [ Title ] ]
            [ text title ]
        ]


arrivalRows : List Arrival -> List (Html Msg)
arrivalRows arrivals =
    arrivals
        |> List.map View.Arrival.view
