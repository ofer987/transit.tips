module Model.Route exposing (..)

import Model.Arrival as Arrival exposing (Arrival)


type Agency
    = TTC
    | Other


type alias Route =
    { id : String
    , title : String
    , arrivals : List Arrival

    -- Change to Stop
    , location : String
    , agency : Agency
    }


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
            Other
