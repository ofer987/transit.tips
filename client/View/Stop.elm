module View.Stop exposing (view)

import Regex
import List
import Maybe
import MyCss exposing (..)
import Html exposing (Html, text)
import Html.CssHelpers
import Model exposing (..)
import Bootstrap.Table exposing (Row, Cell, tr, td, cellAttr)


{ class, classList } =
    Html.CssHelpers.withNamespace "TransitTips"


view : Int -> String -> Row ControllerMsg
view minutes location =
    tr
        []
        [ column location MyCss.Direction
        , column (toString minutes) MyCss.Arrival
        ]


otherTitle : String -> String
otherTitle value =
    value


ttcTitle : String -> String
ttcTitle value =
    value
        |> Regex.find (Regex.AtMost 1) (Regex.regex "(?:towards|to) (.*)\\s*")
        |> List.map .submatches
        |> List.concat
        |> List.map (Maybe.withDefault value)
        |> List.head
        |> Maybe.withDefault value
