module Model exposing (..)

import Model.Nearby as Nearby
import Model.SearchResults as SearchResults


type ControllerMsg
    = NearbyController Nearby.Msg
    | SearchController SearchResults.Msg


type alias Model =
    { nearby : Nearby.Model
    , search : SearchResults.Model
    }


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
    stops
        |> List.sortBy (distance latitude longitude)


distance : Float -> Float -> Stop -> Float
distance latitude longitude stop =
    sqrt (((stop.latitude - latitude) ^ 2) + ((stop.longitude - longitude) ^ 2))
