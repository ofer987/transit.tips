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
                                resultStops ++ headStops

                            newResult =
                                { result | stops = Stops totalStops }
                        in
                            flatten (newResult :: others) tail

                    Nothing ->
                        flatten (head :: results) tail

        [] ->
            results


flattenStops : List Direction -> List Direction -> List Direction
flattenStops results original =
    case original of
        head :: tail ->
            let
                stops =
                    case head.stops of
                        Stops list ->
                            list

                flattenedStops =
                    Model.Stop.flatten [] stops

                newHead =
                    { head | stops = Stops flattenedStops }
            in
                flattenStops (newHead :: results) tail

        [] ->
            results


areEqual : Direction -> Direction -> Bool
areEqual source target =
    if source.id == Nothing || target.id == Nothing then
        source.title == target.title
    else
        source.id == target.id
