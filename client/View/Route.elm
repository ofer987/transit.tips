module View.Route exposing (view)

import View.Route.TTC
import View.Route.Other
import Model exposing (ControllerMsg)
import Model.Common exposing (Route, Agency(..), toAgency)
import Html exposing (Html)


view : Route -> Html ControllerMsg
view route =
    case toAgency route.agencyId of
        TTC ->
            View.Route.TTC.view route

        Other ->
            View.Route.Other.view route
