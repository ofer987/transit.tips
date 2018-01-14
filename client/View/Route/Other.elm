module View.Route.Other exposing (view)

import MyCss exposing (..)
import Html.CssHelpers
import Html exposing (Html, span, text)
import Model exposing (..)
import Model.Route exposing (Route)
import Model.Arrival exposing (Arrival)
import View.Arrival.Other
import Bootstrap.Table exposing (THead, TBody, simpleTable, simpleThead, th, tbody)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "TransitTips"


view : Route -> Html ControllerMsg
view route =
    simpleTable
        ( head (route.title ++ " (" ++ route.location ++ ")")
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
        (List.map View.Arrival.Other.view arrivals)
