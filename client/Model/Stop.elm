module Model.Stop exposing (title, ttcTitle, sort, flatten)

import Regex
import Model.Common exposing (..)


title : Agency -> String -> String
title agency value =
    case agency of
        TTC ->
            ttcTitle value

        Else ->
            value



-- NOTE: this function is currently not used
-- TODO: use this function


ttcTitle : String -> String
ttcTitle value =
    value
        |> Regex.find (Regex.AtMost 1) (Regex.regex "(?:towards|to) (.*)\\s*")
        |> List.map .submatches
        |> List.concat
        |> List.map (Maybe.withDefault value)
        |> List.head
        |> Maybe.withDefault value


sort : Stops -> Stops
sort original =
    let
        list =
            case original of
                Stops r ->
                    r
    in
        Stops (List.sortBy .id list)


flatten : List Stop -> List Stop -> List Stop
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
                            resultArrivals =
                                case result.arrivals of
                                    Arrivals list ->
                                        list

                            headArrivals =
                                case head.arrivals of
                                    Arrivals list ->
                                        list

                            totalArrivals =
                                resultArrivals ++ headArrivals

                            newResult =
                                { result | arrivals = Arrivals totalArrivals }
                        in
                            flatten (newResult :: others) tail

                    Nothing ->
                        flatten (head :: results) tail

        [] ->
            results
