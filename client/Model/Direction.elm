module Model.Direction exposing (..)

import Model.Common exposing (..)
import Model.Stop


sort : Directions -> Directions
sort original =
    let
        list =
            case original of
                Directions r ->
                    r

        sorted =
            list
                |> List.sortBy .id
                |> List.map (\direction -> { direction | stops = Model.Stop.sort direction.stops })
    in
        Directions sorted


flatten : List Direction -> List Direction -> List Direction
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
                            resultStops =
                                case result.stops of
                                    Stops list ->
                                        list

                            headStops =
                                case head.stops of
                                    Stops list ->
                                        Model.Stop.flatten [] list

                            newResult =
                                { result | stops = Stops (resultStops ++ headStops) }
                        in
                            flatten (newResult :: others) tail

                    Nothing ->
                        flatten (head :: results) tail

        [] ->
            results
