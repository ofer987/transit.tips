module Convert.Route exposing (..)

import Json.Route exposing (..)
import Json.Common exposing (..)
import Model
import List


toRoute : Route -> Model.Route
toRoute json =
    Model.Route
        json.id
        json.title
        json.agency
        (List.map (toDirection json.stop) json.arrivals)


toDirection : Stop -> Arrival -> Model.Direction
toDirection stop arrival =
    Model.Direction
        arrival.direction.id
        arrival.direction.shortTitle
        arrival.direction.title
        [ toStop (stop arrival) ]


toStop : Stop -> Arrival -> Model.Stop
toStop stop =
    Model.Stop
        stop.id
        stop.title
        (toLocation stop.latitude stop.longitude)
        [ toArrival arrival ]


toLocation : Float -> Float -> Model.Location
toLocation latitude longitude =
    Model.Location
        latitude
        longitude


toArrival : Arrival -> Model.Arrival
toArrival arrival =
    Model.Arrival
        arrival.minutes
        arrival.seconds
