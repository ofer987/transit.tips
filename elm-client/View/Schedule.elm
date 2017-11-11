module View.Schedule exposing (view)

import List
import Html exposing (Html, div)
import Model exposing (..)
import View.Route
import Model.Schedule exposing (Schedule)


view : Schedule -> Html Msg
view schedule =
    div
        []
        (List.map View.Route.view schedule.routes)
