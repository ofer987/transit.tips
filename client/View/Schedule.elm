module View.Schedule exposing (views)

import List
import Html exposing (Html, div, text)
import Html.Attributes exposing (id)
import Model exposing (..)
import View.Route
import MyCss exposing (..)
import Html.CssHelpers
import Bootstrap.Table exposing (simpleTable, simpleThead, th, tbody, cellAttr)
import Model.Schedule exposing (Schedule)


-- TODO: add id


{ class, classList } =
    Html.CssHelpers.withNamespace "TransitTips"


views : Schedule -> List (Html Msg)
views schedule =
    head :: (List.map View.Route.view schedule.routes)


head : Html Msg
head =
    simpleTable
        ( simpleThead
            [ th
                [ cellAttr (id "direction")
                , cellAttr (class [ Direction ])
                ]
                [ text "Direction" ]
            , th
                [ cellAttr (id "arrival")
                , cellAttr (class [ Arrival ])
                ]
                [ text "Arrival (in minutes)" ]
            ]
        , tbody [] []
        )
