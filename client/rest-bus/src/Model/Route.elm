module Model.Route exposing (toAgency, sort, sortByDirections, flatten, toList)

import Model.Common exposing (..)
import Model.Direction
import String exposing (toInt)


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
            (sortByInt list ++ sortByString list)
                |> List.map (\route -> { route | directions = Model.Direction.sort route.directions })
    in
        Routes sorted


isInt : String -> Bool
isInt value =
    case toInt value of
        Ok _ ->
            True

        Err _ ->
            False


sortByInt : List Route -> List Route
sortByInt original =
    let
        filtered =
            List.filter (\route -> isInt route.id) original

        strToInt : String -> Int
        strToInt string =
            case toInt string of
                Ok int ->
                    int

                Err _ ->
                    0
    in
        List.sortBy (\route -> strToInt route.id) filtered


sortByString : List Route -> List Route
sortByString original =
    let
        filtered =
            List.filter (\route -> not (isInt route.id)) original
    in
        List.sortBy .id filtered


sortByDirections : Float -> Float -> Route -> List Stop
sortByDirections latitude longitude route =
    route.directions
        |> Model.Direction.toList
        |> List.filterMap (Model.Direction.sortByDistance latitude longitude)


toList : Routes -> List Route
toList routes =
    case routes of
        Routes list ->
            list


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
