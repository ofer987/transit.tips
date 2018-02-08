module Model.Flatten exposing (..)

import Model.Common as Model exposing (..)
import List


-- TODO: use polymorphism so to have only one common function


stops : List Stop -> List Stop -> List Stop
stops results original =
    case original of
        head :: tail ->
            let
                existing =
                    results
                        |> List.filter (\item -> item.id == head.id)
                        |> List.head
            in
                case existing of
                    Just result ->
                        stops results tail

                    Nothing ->
                        stops (head :: results) tail

        [] ->
            results


directions : List Direction -> List Direction -> List Direction
directions results original =
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
                                        stops [] list

                            newResult =
                                { result | stops = Stops (resultStops ++ headStops) }
                        in
                            directions (newResult :: others) tail

                    Nothing ->
                        directions (head :: results) tail

        [] ->
            results


routes : List Route -> List Route -> List Route
routes results original =
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
                                        directions [] list

                            newResult =
                                { result | directions = Directions (resultDirections ++ headDirections) }
                        in
                            routes (newResult :: others) tail

                    Nothing ->
                        routes (head :: results) tail

        [] ->
            results
