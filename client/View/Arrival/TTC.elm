module View.Arrival.TTC exposing (view)

import Regex
import List
import Maybe
import MyCss exposing (..)
import Html exposing (Html, text)
import Html.CssHelpers
import Model exposing (..)
import Model.Common exposing (Arrival)
import Bootstrap.Table exposing (Row, Cell, tr, td, cellAttr)


{ class, classList } =
    Html.CssHelpers.withNamespace "TransitTips"


view : Arrival -> Row ControllerMsg
view arrival =
    tr
        []
        [ column arrival.parent.title MyCss.Direction
        , column (toString arrival.minutes) MyCss.Arrival
        ]


column : String -> CssClasses -> Cell ControllerMsg
column value cls =
    td
        [ cellAttr (class [ cls ]) ]
        [ text value ]


location : String -> String
location value =
    value
        |> Regex.find (Regex.AtMost 1) (Regex.regex "(?:towards|to) (.*)\\s*")
        |> List.map .submatches
        |> List.concat
        |> List.map (Maybe.withDefault value)
        |> List.head
        |> Maybe.withDefault value
