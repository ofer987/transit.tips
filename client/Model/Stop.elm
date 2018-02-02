module Model.Stop exposing (..)

import Regex
import Model.Route exposing (Agency(..))


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
