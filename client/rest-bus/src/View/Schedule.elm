module View.Schedule exposing (view)

import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class, id)
import Model exposing (..)
import MyCss exposing (..)


-- import Html.CssHelpers

import Model.Common exposing (..)
import View.Routes


-- { class, classList } =
--     Html.CssHelpers.withNamespace "TransitTips"


view : Routes -> Html Controller
view routes =
    div
        []
        [ head
        , View.Routes.view routes
        ]


head : Html Controller
head =
    div
        [ class "MyCss.Headings" ]
        [ span [ id "direction", class "MyCss.Direction" ] [ text "Direction" ]
        , span [ id "arrival", class "MyCss.Arrival" ] [ text "Arrival (in minutes)" ]
        , div [ class "MyCss.Clearing" ] []
        ]
