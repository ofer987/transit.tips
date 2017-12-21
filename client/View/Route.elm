module View.Route exposing (view)

import MyCss exposing (..)
import Html.CssHelpers
import Html exposing (Html, div, span, text)
import Model exposing (..)
import Model.Route exposing (Route)
import Model.Arrival exposing (Arrival)
import View.Arrival
import View.AgencyLogo
import Bootstrap.Table exposing (THead, TBody, simpleTable, simpleThead, th, tbody, tr, td, cellAttr)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "TransitTips"


view : Route -> Html Msg
view route =
    div
        []
        [ simpleTable
            ( simpleThead []
            , tbody
                []
                [ tr
                    []
                    [ td [ cellAttr (class []) ] [ View.AgencyLogo.view route.agencyUrl ]
                    , td [ cellAttr (class []) ] [ simpleTable ( head route.title, body route.agencyUrl route.arrivals ) ]
                    ]
                ]
            )
        ]


head : String -> THead Msg
head value =
    simpleThead
        [ th [] [ text value ] ]


body : String -> List Arrival -> TBody Msg
body agencyUrl arrivals =
    tbody
        [ class [ MyCss.Route ] ]
        (List.map (View.Arrival.view agencyUrl) arrivals)
