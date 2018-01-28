module Json.Convert.Predictions exposing (..)

import Json.Predictions exposing (..)
import Model.Common
import List


toSchedule : Schedule -> Model.Common.Schedule
toSchedule json =
    let
        self =
            Model.Common.Schedule
                (Model.Common.Location json.latitude json.longitude)
                json.address
                (Model.Common.Routes [])

        schedule =
            Model.Common.Schedule
                (Model.Common.Location json.latitude json.longitude)
                json.address
                (Model.Common.Routes (List.map (toRoute self) json.routes))
    in
        schedule


toRoute : Model.Common.Schedule -> Route -> Model.Common.Route
toRoute parent json =
    let
        self =
            Model.Common.Route
                json.id
                parent
                json.title
                json.agencyId
                (Model.Common.Directions [])

        route =
            Model.Common.Route
                json.id
                parent
                json.title
                json.agencyId
                (Model.Common.Directions (List.map (toDirection self json.stop) json.arrivals))
    in
        route


toDirection : Model.Common.Route -> Stop -> Arrival -> Model.Common.Direction
toDirection parent stop arrival =
    let
        self =
            Model.Common.Direction
                arrival.direction.id
                parent
                ""
                arrival.direction.title
                (Model.Common.Stops [])

        direction =
            Model.Common.Direction
                arrival.direction.id
                parent
                ""
                arrival.direction.title
                (Model.Common.Stops [ toStop self stop arrival ])
    in
        direction


toStop : Model.Common.Direction -> Stop -> Arrival -> Model.Common.Stop
toStop parent json arrival =
    let
        self =
            Model.Common.Stop
                json.id
                parent
                json.title
                Nothing
                (Model.Common.Arrivals [])

        stop =
            Model.Common.Stop
                json.id
                parent
                json.title
                Nothing
                (Model.Common.Arrivals [ toArrival self arrival ])
    in
        stop


toArrival : Model.Common.Stop -> Arrival -> Model.Common.Arrival
toArrival parent json =
    Model.Common.Arrival
        parent
        json.minutes
        json.seconds
