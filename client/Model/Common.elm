module Model.Common exposing (..)

type Agency
    = TTC
    | Other


type alias Route =
    { id : String
    , title : String
    , agency : Agency
    , directions : List Direction
    }


type alias Direction =
    { id : String
    , shortTitle : String
    , title : String
    , stops : List Stop
    }


type alias Stop =
    { id : String
    , title : String
    , location : Maybe Location
    , arrivals : List Arrival
    }


type alias Location =
    { latitude : Float
    , longitude : Float
    }


type alias Arrival =
    { minutes : Int
    , seconds : Int
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


sortedStopsByPosition : Float -> Float -> List Stop -> List Stop
sortedStopsByPosition latitude longitude stops =
    let
        range : Stop -> Float
        range stop =
            case stop.location of
                Just location ->
                    distance latitude longitude location

                Nothing ->
                    -- Max Value
                    2 ^ 32 - 1
    in
        List.sortBy range stops

isJust : Maybe a -> Bool
isJust value =
    case value of
        Just _ ->
            True

        Nothing ->
            False

distance : Float -> Float -> Location -> Float
distance latitude longitude location =
    sqrt (((location.latitude - latitude) ^ 2) + ((location.longitude - longitude) ^ 2))
