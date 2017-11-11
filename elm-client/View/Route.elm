module View.Route exposing (view)

import List exposing (List)
import Html exposing (tbody, tr, td, span, text)
import Model.Route exposing (Route)
import View.Arrival exposing (view)


view : Arrival -> Html Msg
view arrival =
    tbody
        [ class RouteBody ]
        (titleRow :: arrivalRows)


titleRow : String -> Html Msg
titleRow title =
    [ tr
        []
        [ span
            [ class RouteTitle ]
            [ text title ]
        ]
    ]


arrivalRows : List Arrival -> List (Html Msg)
arrivalRows arrivals =
    arrivals
        |> List.map View.Arrival.view
