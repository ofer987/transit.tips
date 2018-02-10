module Model.Stop exposing (sort, flatten)

import Model.Common exposing (..)


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
