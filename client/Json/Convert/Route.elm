module Json.Convert.Route exposing (..)

import Json.Route exposing (..)
import Model
import List


toSchedule : Schedule -> Model.Common.Schedule
toSchedule json =
    Model.Common.Schedule
    (Model.Common.Location json.latitude json.longitude)
    json.address
    (List.map toRoute json.routes)

toRoute : Route -> Model.Common.Route
toRoute json =
    Model.Common.Route
        json.id
        json.title
        json.agency
        (List.map (toDirection json.stop) json.arrivals)


-- TODO: figure out whether to filer the route.stops by direction.stops
toDirection : Stop -> Arrival -> Model.Common.Direction
toDirection stop arrival =
    Model.Common.Direction
        arrival.direction.id
        arrival.direction.shortTitle
        arrival.direction.title
        [ toStop (stop arrival) ]


toStop : Stop -> Arrival -> Model.Common.Stop
toStop stop =
    Model.Common.Stop
        stop.id
        stop.title
        (toLocation stop.latitude stop.longitude)
        [ toArrival arrival ]


toLocation : Float -> Float -> Model.Common.Location
toLocation latitude longitude =
    Model.Common.Location
        latitude
        longitude


toArrival : Arrival -> Model.Common.Arrival
toArrival arrival =
    Model.Common.Arrival
        arrival.minutes
        arrival.seconds
