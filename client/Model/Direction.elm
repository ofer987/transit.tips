module Model.Direction exposing (sort, flatten)

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
                |> List.sortBy .title
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
                        |> List.filter (areEqual head)
                        |> List.head

                others =
                    results
                        |> List.filter (\item -> not (areEqual head item))
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
                                        list

                            totalStops =
                                (resultStops ++ headStops)
                                    |> Model.Stop.flatten []

                            -- TODO: Flatten both result and head stops
                            newResult =
                                { result | stops = Stops totalStops }
                        in
                            flatten (newResult :: others) tail

                    Nothing ->
                        let
                            stops =
                                case head.stops of
                                    Stops list ->
                                        list

                            totalStops =
                                stops
                                    |> Model.Stop.flatten []

                            newHead =
                                { head | stops = Stops totalStops }
                        in
                            flatten (newHead :: results) tail

        [] ->
            results


areEqual : Direction -> Direction -> Bool
areEqual source target =
    if source.id == Nothing || target.id == Nothing then
        source.title == target.title
    else
        source.id == target.id
