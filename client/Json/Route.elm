module Json.Route exposing (..)

import Json.Stop as Stop exposing (Stop)
import Json.Arrival as Arrival exposing (Arrival)
import List
import Model.Route exposing (Agency)


type alias MyRoute =
    { id : String
    , agencyId : String
    , directions : List MyDirection
    , stop : List Stop
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
    , agency : Agency
    , stop : Stop
    , arrivals : List Arrival
    }


sortedAndFilteredStops : Float -> Float -> List String -> List Stop -> List Stop
sortedAndFilteredStops latitude longitude stopIds stops =
    stops
        |> List.filter (\stop -> List.member stop.id stopIds)
        |> sortedStopsByPosition latitude longitude


toModel : Route -> Model.Route.Route
toModel json =
    Model.Route.Route json.id json.title json.agency (List.map (toDirection json.stop) json.arrivals)


toDirection : Stop -> Arrival -> Model.Direction.Direction
toDirection stop arrival =
    Model.Direction.Direction arrival.direction.id "" arrival.direction.title [ toStop (stop arrival) ]


toStop : Stop -> Arrival -> Model.Stop.Stop
toStop stop =
    Model.Stop.Stop stop.id stop.title 0.0 0.0 [ toArrival arrival ]


toArrival : Arrival -> Model.Arrival.Arrival
toArrival arrival =
    Model.Arrival.Arrival "" arrival.time
