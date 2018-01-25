module Model.Common exposing (..)


type Agency
    = TTC
    | Other


type alias Schedule =
    { location : Location
    , address : Maybe String
    , routes : List Route
    }


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


sortByStop : Float -> Float -> List Route -> List Route
sortByStop latitude longitude routes =
    List.sortBy (routeDistance latitude longitude) routes


routeDistance : Float -> Float -> Route -> Float
routeDistance latitude longitude route =
    case route.direction.location of
        Just value ->
            distance latitude longitude value.latitude value.longitude

        Nothing ->
            (2 ^ 32) - 1


distance : Float -> Float -> Float -> Float -> Float
distance latitude1 longitude1 latitude2 longitude2 =
    sqrt (((latitude2 - latitude1) ^ 2) + ((longitude2 - longitude1) ^ 2))
