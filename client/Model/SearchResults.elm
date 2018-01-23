-- Rename to Model.Search


module Model.SearchResults exposing (..)

import Http
import Geolocation exposing (Location)
import Model.Stop exposing (Stop)
import Model.Route exposing (MyRoute, Route)


type Msg
    = None
    | GetLocation String
    | SetLocation Location String
    | UnavailableLocation Geolocation.Error
    | RequestRoute Location String
    | ReceiveRoute (Result Http.Error MyRoute)
    | ReceivePredictions (Result Http.Error (Maybe Route))


type Model
    = NoLocation
    | ReceivedLocation Float Float
    | ReceivedRoute Float Float (List Stop)
    | ReceivedArrivals Route
    | Error String


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
    , arrivals : List Arrival
    }


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
