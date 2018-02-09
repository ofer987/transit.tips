module Model.Route exposing (toAgency, sort, flatten)

import Model.Common exposing (..)
import Model.Direction


toAgency : String -> Agency
toAgency value =
    let
        lowerAndTrimmed =
            value
                |> String.trim
                |> String.toLower
    in
        if lowerAndTrimmed == "ttc" then
            TTC
        else
            Else


sort : Routes -> Routes
sort original =
    let
        list =
            case original of
                Routes r ->
                    r

        sorted =
            list
                |> List.sortBy .id
                |> List.map (\route -> { route | directions = Model.Direction.sort route.directions })
    in
        Routes sorted


flatten : List Route -> List Route -> List Route
flatten results original =
    case original of
        head :: tail ->
            let
                existing =
                    results
                        |> List.filter (\item -> item.id == head.id)
                        |> List.head

                others =
                    results
                        |> List.filter (\item -> item.id /= head.id)
            in
                case existing of
                    Just result ->
                        let
                            resultDirections =
                                case result.directions of
                                    Directions list ->
                                        list

                            headDirections =
                                case head.directions of
                                    Directions list ->
                                        list

                            totalDirections =
                                resultDirections ++ headDirections

                            newResult =
                                { result | directions = Directions totalDirections }
                        in
                            flatten (newResult :: others) tail

                    Nothing ->
                        flatten (head :: results) tail

        [] ->
            flattenDirections [] results


flattenDirections : List Route -> List Route -> List Route
flattenDirections results original =
    case original of
        head :: tail ->
            let
                directions =
                    case head.directions of
                        Directions list ->
                            list

                flattenedDirections =
                    Model.Direction.flatten [] directions

                newHead =
                    { head | directions = Directions flattenedDirections }
            in
                flattenDirections (newHead :: results) tail

        [] ->
            results
