module Model.Schedule exposing (agencyIds)

import List
import Model.Common exposing (Schedule)
import Model.Route
import Utility.List


agencyIds : Schedule -> List String
agencyIds schedule =
    schedule.routes
        |> Model.Route.toList
        |> List.map .agencyId
        |> Utility.List.distinct
