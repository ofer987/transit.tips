module Convert.Search.Route exposing (..)

import Json.Route exposing (Route)
import Json.Stop as Stop exposing (Stop)
import Json.Arrival as Arrival exposing (Arrival)
import List
import Model.Route exposing (Agency)


toRoute : Route -> Model.Route.Route
toRoute json =
    Model.Route.Route
        json.id
        json.title
        json.agency
        (List.map (toDirection json.stop) json.arrivals)


toDirection : Stop -> Arrival -> Model.Direction.Direction
toDirection stop arrival =
    Model.Direction.Direction
        arrival.direction.id
        arrival.direction.shortTitle
        arrival.direction.title
        [ toStop (stop arrival) ]


toStop : Stop -> Arrival -> Model.Stop.Stop
toStop stop =
    Model.Stop.Stop
        stop.id
        stop.title
        [ toArrival arrival ]


toArrival : Arrival -> Model.Arrival.Arrival
toArrival arrival =
    Model.Arrival.Arrival
        arrival.minutes
        arrival.seconds
