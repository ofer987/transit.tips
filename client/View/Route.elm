module View.Route exposing (view)

import View.Route.TTC
import View.Route.Other
import Model exposing (Msg)
import Model.Route as Route exposing (Route, Agency(..))
import Html exposing (Html)


view : Route -> Html Msg
view route =
    case route.agency of
        TTC ->
            View.Route.TTC.view route

        Other ->
            View.Route.Other.view route
