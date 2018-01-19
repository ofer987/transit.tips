module Json.Schedule exposing (..)

import Json.Route as Route exposing (Route)
import Model.Schedule
import List


type alias Schedule =
    { routes : List Route
    }

toModel : Schedule -> Model.Schedule.Schedule
toModel json =
    { routes = List.map Json.Route.toModel json.routes }

