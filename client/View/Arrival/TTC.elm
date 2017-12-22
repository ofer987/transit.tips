module View.Arrival.TTC exposing (view)

import Regex
import List
import Maybe
import MyCss exposing (..)
import Html exposing (Html, text)
import Html.CssHelpers
import Model exposing (..)
import Model.Arrival exposing (Arrival)
import Bootstrap.Table exposing (Row, Cell, tr, td, cellAttr)


{ class, classList } =
    Html.CssHelpers.withNamespace "TransitTips"


view : Arrival -> Row Msg
view arrival =
    tr
        []
        [ column (location arrival.title) MyCss.Direction
        , column (toString arrival.time) MyCss.Arrival
        ]


column : String -> CssClasses -> Cell Msg
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
