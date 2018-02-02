module View.Schedule exposing (views)

import Html exposing (Html, div, text)
import Html.Attributes exposing (id)
import Model exposing (..)
import MyCss exposing (..)
import Html.CssHelpers
import Bootstrap.Table exposing (simpleTable, simpleThead, th, tbody, cellAttr)
import Model.Common exposing (..)
import View.Routes


-- TODO: add id


{ class, classList } =
    Html.CssHelpers.withNamespace "TransitTips"


views : Schedule -> Html Controller
views schedule =
    div
        []
        [ head
        , View.Routes.view schedule.routes
        ]


head : Html Controller
head =
    simpleTable
        ( simpleThead
            [ th
                [ cellAttr (id "direction")
                , cellAttr (class [ MyCss.Direction ])
                ]
                [ text "Direction" ]
            , th
                [ cellAttr (id "arrival")
                , cellAttr (class [ MyCss.Arrival ])
                ]
                [ text "Arrival (in minutes)" ]
            ]
        , tbody [] []
        )
