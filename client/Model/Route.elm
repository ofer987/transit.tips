module Model.Route exposing (..)

import Model.Stop as Stop exposing (Stop)
import Model.Arrival as Arrival exposing (Arrival)


type Agency
    = TTC
    | Other


type alias MyRoute =
    { id : String
    , agencyId : String
    , stops : List Stop
    , myLatitude : Float
    , myLongitude : Float
    }


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
