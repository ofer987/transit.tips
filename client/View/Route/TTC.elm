module View.Route.TTC exposing (view)

import MyCss exposing (..)
import Html.CssHelpers
import Html exposing (Html, span, text)
import Regex
import List
import Maybe
import Model exposing (..)
import Model.Route exposing (Route)
import Model.Arrival exposing (Arrival)
import View.Arrival.TTC
import Bootstrap.Table exposing (THead, TBody, simpleTable, simpleThead, th, tbody)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "TransitTips"


view : Route -> Html ControllerMsg
view route =
    simpleTable
        ( head (route.title ++ " (" ++ location route.location ++ ")")
        , body route.arrivals
        )


head : String -> THead ControllerMsg
head value =
    simpleThead
        [ th [] [ text value ] ]


body : List Arrival -> TBody ControllerMsg
body arrivals =
    tbody
        [ class [ MyCss.Route ] ]
        (List.map View.Arrival.TTC.view arrivals)


location : String -> String
location value =
    value
        |> Regex.find (Regex.AtMost 1) (Regex.regex "Stop: (.*)\\s*")
        |> List.map (\match -> match.submatches)
        |> List.concat
        |> List.map (Maybe.withDefault value)
        |> List.head
        |> Maybe.withDefault value
