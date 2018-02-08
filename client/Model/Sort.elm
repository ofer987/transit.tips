module Model.Sort exposing (..)

import Model.Common as Model exposing (..)
import List


routes : Routes -> Routes
routes original =
    let
        list =
            case original of
                Routes r ->
                    r

        sorted =
            list
                |> List.sortBy .id
                |> List.map (\route -> { route | directions = directions route.directions })
    in
        Routes sorted


directions : Directions -> Directions
directions original =
    let
        list =
            case original of
                Directions r ->
                    r

        sorted =
            list
                |> List.sortBy .id
                |> List.map (\direction -> { direction | stops = stops direction.stops })
    in
        Directions sorted


stops : Stops -> Stops
stops original =
    let
        list =
            case original of
                Stops r ->
                    r
    in
        Stops (List.sortBy .id list)
