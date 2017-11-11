module View.Schedule exposing (view)

import Model exposing (..)
import List
import View.Route


view : Schedule -> Html Msg
view schedule =
    schedule.routes
        |> List.map View.Route.view
