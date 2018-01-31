module Json.Convert.Route exposing (..)

import Json.Route exposing (..)
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
                (Model.Common.Directions (List.map (toDirection self) json.stops))
    in
        route


toDirection : Model.Common.Route -> Stop -> Model.Common.Direction
toDirection parent json =
    let
        self =
            Model.Common.Direction
                ""
                parent
                ""
                ""
                (Model.Common.Stops [])

        direction =
            Model.Common.Direction
                ""
                parent
                ""
                ""
                (Model.Common.Stops [ toStop self json ])
    in
        direction


toStop : Model.Common.Direction -> Stop -> Model.Common.Stop
toStop parent json =
    Model.Common.Stop
        json.id
        parent
        json.title
        Nothing
        (Model.Common.Arrivals [])
