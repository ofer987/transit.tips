module Model.Route exposing (..)

import Model.Stop as Stop exposing (Stop)
import Model.Arrival as Arrival exposing (Arrival)
import List
import Model.Stop exposing (sortedStopsByPosition)


type Agency
    = TTC
    | Other


type alias MyRoute =
    { id : String
    , agencyId : String
    , directions : List MyDirection
    , stops : List Stop
    , myLatitude : Float
    , myLongitude : Float
    }


type alias MyDirection =
    { id : String
    , shortTitle : String
    , title : String
    , stops : List String
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


sortedAndFilteredStops : Float -> Float -> List String -> List Stop -> List Stop
sortedAndFilteredStops latitude longitude stopIds stops =
    stops
        |> List.filter (\stop -> List.member stop.id stopIds)
        |> sortedStopsByPosition latitude longitude
