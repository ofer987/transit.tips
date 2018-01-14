module View.Arrival.Other exposing (view)

import MyCss exposing (..)
import Html exposing (Html, text)
import Html.CssHelpers
import Model exposing (..)
import Model.Arrival exposing (Arrival)
import Bootstrap.Table exposing (Row, Cell, tr, td, cellAttr)


{ class, classList } =
    Html.CssHelpers.withNamespace "TransitTips"


view : Arrival -> Row ControllerMsg
view arrival =
    tr
        []
        [ column arrival.title MyCss.Direction
        , column (toString arrival.time) MyCss.Arrival
        ]


column : String -> CssClasses -> Cell ControllerMsg
column value cls =
    td
        [ cellAttr (class [ cls ]) ]
        [ text value ]
