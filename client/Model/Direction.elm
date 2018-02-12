module Model.Direction exposing (title, sort, sortByDistance, flatten, toList)

import Regex
import Model.Common exposing (..)
import Model.Stop


title : Agency -> String -> String
title agency value =
    case agency of
        TTC ->
            ttcTitle value

        Else ->
            value


ttcTitle : String -> String
ttcTitle value =
    value
        |> Regex.find (Regex.AtMost 1) (Regex.regex "(?:towards|to) (.*)\\s*")
        |> List.map .submatches
        |> List.concat
        |> List.map (Maybe.withDefault value)
        |> List.head
        |> Maybe.withDefault value


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


toList : Directions -> List Direction
toList directions =
    case directions of
        Directions list ->
            list


sortByDistance : Float -> Float -> Direction -> Maybe Stop
sortByDistance latitude longitude direction =
    let
        stops =
            case direction.stops of
                Stops list ->
                    list
    in
        stops
            |> List.sortBy (Model.Stop.distance latitude longitude)
            |> List.head


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
