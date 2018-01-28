module View.Schedule exposing (views)

import List
import Html exposing (Html, div, text)
import Html.Attributes exposing (id)
import Model exposing (..)
import View.Route
import MyCss exposing (..)
import Html.CssHelpers
import Bootstrap.Table exposing (simpleTable, simpleThead, th, tbody, cellAttr)
import Model.Common exposing (..)


-- TODO: add id


{ class, classList } =
    Html.CssHelpers.withNamespace "TransitTips"


views : Schedule -> List (Html ControllerMsg)
views schedule =
    let
        routes =
            case schedule.routes of
                Routes values ->
                    values
    in
        head :: (List.map View.Route.view routes)


head : Html ControllerMsg
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
