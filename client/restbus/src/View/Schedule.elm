module View.Schedule exposing (view)

import Html.Styled exposing (Html, styled, div, span, text)
import Html.Styled.Attributes exposing (class, id)
import Css exposing (padding2, px, property, margin4, float, left, right, fontWeight, bold)
import Model exposing (..)
import MyCss exposing (..)
import Model.Common exposing (..)
import View.Routes


view : Routes -> Html Msg
view routes =
    div
        []
        [ head
        , View.Routes.view routes
        ]


head : Html Msg
head =
    styled div
        [ margin4 (px 15) (px 0) (px 5) (px 0) ]
        [ class "MyCss.Headings" ]
        [ styled span
            [ float left, fontWeight bold ]
            [ id "direction", class "MyCss.Direction" ]
            [ text "Direction" ]
        , styled span
            [ float right, fontWeight bold ]
            [ id "arrival", class "MyCss.Arrival" ]
            [ text "Arrival (in minutes)" ]
        , styled div
            [ property "clear" "both" ]
            [ class "MyCss.Clearing" ]
            []
        ]
