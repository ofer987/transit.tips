module Model.Schedule exposing (agencyIds)

import List
import Model.Common exposing (Schedule)
import Model.Route


agencyIds : Schedule -> List String
agencyIds schedule =
    schedule.routes
        |> Model.Route.toList
        |> List.map .agencyId
        |> filterUnique []


filterUnique : List a -> List a -> List a
filterUnique result remaining =
    case remaining of
        head :: tail ->
            case List.any (\item -> item == head) tail of
                True ->
                    filterUnique result tail

                False ->
                    filterUnique (head :: result) tail

        [] ->
            result
