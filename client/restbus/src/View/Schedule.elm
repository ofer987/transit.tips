module View.Schedule exposing (view)

import Html.Styled exposing (Html, styled, div, span, text)
import Html.Styled.Attributes exposing (class, id)
import Css exposing (padding2, px, property, margin4, float, left, right, fontWeight, bold)
import Model exposing (..)
import MyCss
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
    MyCss.headings [ class "MyCss.Headings" ]
